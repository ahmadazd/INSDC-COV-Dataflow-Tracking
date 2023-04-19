import glob
import os.path
import datetime
import os
import sys
import pathlib

output_dir = config["output_dir"]
wildcard= f"{output_dir}"
folders =[f.path for f in os.scandir(wildcard) if f.is_dir()]
latest_folder = max(folders, key=os.path.getctime)

rule fetch_data:
	input:
		expand("{output_dir}/run_workflow.txt", output_dir = config["output_dir"])
	output:
		expand("{output_dir}/end.txt", output_dir = config["output_dir"])

	resources:
		mem_mb = 15048,
		tmpdir = config["temp_dir"]
	run:
		output_dir = config["output_dir"]
		now = datetime.datetime.now()
		now_str = now.strftime("%d%m%y")
		outdir = f"{output_dir}/databases_logs_{now_str}"
		if not os.path.exists(outdir):
        		os.mkdir(outdir)
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_fetch_script.py -r all -org 2697049 -db sequences -o {outdir}")
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_fetch_script.py -r all -org 2697049 -db reads -o {config[output_dir]} -of $(ls {config[output_dir]} -rt | tail -n1) && touch {output}")
