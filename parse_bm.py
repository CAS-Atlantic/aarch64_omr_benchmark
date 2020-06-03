#!/usr/bin/python3

import argparse
import os
import re

HEADER_LIST = [ ]
EXTRA_ITEM_HEADER_LIST = []

RE = {}

ADD_IEMS = {}

def sanitize(input_str: str = None):
    return " ".join(input_str.split())

def parse_my_args():
    # foward declare the arguments
    results = None
    parser = argparse.ArgumentParser(description='Parse a text file to a csv using defined capture group')
    parser.add_argument('--no_print_header',help='do not print the headers', action='store_true', default=False)
    parser.add_argument('--add_column',action='append',nargs=2, metavar=('csv_header','csv_item'),help='help:')
    parser.add_argument('config_file', help='expect a .conf file')
    parser.add_argument('input_file_list', help='expect a list of file', nargs='+')

    try:
        results = parser.parse_args()
    except IOError as msg:
        parser.error(str(msg))
        exit(-1)

    if results.add_column is not None:
        for extra_items in results.add_column:
            EXTRA_ITEM_HEADER_LIST.append(extra_items[0])
            ADD_IEMS[extra_items[0]] = extra_items[1]

    return results

def parse_conf(conf_file_name: str = None):

    # sanitize file name
    conf_file_name = conf_file_name.strip()
    current_file_directory = os.path.dirname(conf_file_name)
    if conf_file_name is not None:
        with open(conf_file_name, 'r') as config_file:
            for line in config_file:
                if line.startswith('#include'):
                    parse_conf( os.path.join(current_file_directory, line.split("\"", 1)[1].split("\"", 1)[0] ) )
                elif not line.startswith('#'):
                    # sanitize and split
                    line_split = sanitize(line).split("=", 1)

                    if len(line_split) == 2:
                        header = sanitize(line_split[0])
                        capture_group = sanitize(line_split[1])
                        RE[header] = re.compile(capture_group)
                        HEADER_LIST.append(header)

def parse_txt(txt_file_name: str = None):
    csv_output = {}

    for header in HEADER_LIST:
        csv_output[header] = "N/A"

    if txt_file_name is not None:
        with open(txt_file_name, 'r') as text_file:
            for line in text_file:
                clean_line = sanitize(line)

                for header in HEADER_LIST: 
                    regex_match = re.match(RE[header], clean_line)
                    if regex_match is not None and regex_match.group(1) is not None:
                        csv_output[header] = str(regex_match.group(1))

    line = txt_file_name
    for item in EXTRA_ITEM_HEADER_LIST:
        line += str("," + ADD_IEMS[item].replace(",",""))

    for header in HEADER_LIST:
        line += str("," + csv_output[header].replace(",",""))

    print(line)



def main():
    results = parse_my_args()
    parse_conf(results.config_file)
    
    if not results.no_print_header:

        line = '__file_name__'
        for item in EXTRA_ITEM_HEADER_LIST:
            line += str("," + item.replace(",",""))

        for header in HEADER_LIST:
            line += str("," + header.replace(",",""))

        print(line)

    for files in results.input_file_list:
        parse_txt(files)


if __name__ == "__main__":
    main()
