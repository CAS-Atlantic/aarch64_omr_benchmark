#!/bin/python3
# Authors: Aaron Graham (aaron.graham@unb.ca, aarongraham9@gmail.com) and
#          Jean-Philippe Legault (jlegault@unb.ca, jeanphilippe.legault@gmail.com)
#           for the Centre for Advanced Studies - Atlantic (CAS-Atlantic) at the
#            Univerity of New Brunswick in Fredericton, New Brunswick, Canada

import argparse
import os

import pandas
import plotly.graph_objects as go
from plotly.subplots import make_subplots

def parse_my_args():
    # foward declare the arguments
    results = None
    parser = argparse.ArgumentParser(description='Plot a csv')
    parser.add_argument('input_csv', help='expect a .csv file')

    try:
        results = parser.parse_args()
    except IOError as msg:
        parser.error(str(msg))
        exit(-1)

    return results

def plot_specjvm_opsm(df):
    # Create figure
    fig = make_subplots()

    
    baseline_table = 'specjvm2008_jdk11_aarch64'
    platform_baseline = None
    platform_subtable = {}
    relative_values = {}
    for platforms in df['benchmark_platform'].unique():
        if platforms != baseline_table:
            platform_subtable[platforms] = df.loc[df['benchmark_platform'] == platforms, 'Itteratio ops/m']
            relative_values[platforms] = []
        else:
            platform_baseline = df.loc[df['benchmark_platform'] == platforms, 'Itteratio ops/m']

    y_axis = df['Name'].unique()

    for bm in y_axis:
        baseline_value = df[('specjvm2008_jdk11_aarch64', bm), 'Itteratio ops/m'] 

        for platforms in df['benchmark_platform'].unique():
            if platforms != baseline_table:
                if platforms not in relative_values:
                     = []

                value = df[(platforms, bm), 'Itteratio ops/m'] 
                relative_values[platforms].append(value / baseline_value)
                
    for platforms in platform_subtable:
        fig.add_trace(go.Bar(y=y_axis, x=relative_values[platforms], name = platforms, orientation='h'))

    fig.update_layout(
        title_text="ops/m difference", 
        legend=dict(x=-0.0, y=-0.5),
        xaxis_type="log",
        autosize=False,
        width=2000,
        height=2000
    )

    fig.update_yaxes(title_text="benchmark")
    fig.update_xaxes(title_text="ops/m")

    fig.write_image("SPECjvm2008_opsm.svg")

def main():
    results = parse_my_args()
    df = pandas.read_csv(results.input_csv)
    plot_specjvm_opsm(df)



if __name__ == "__main__":
    main()
