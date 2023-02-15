import glob
import os.path
output_dir = config["output_dir"]
wildcard= f"{output_dir}"
folders = glob.glob(f"{wildcard}/*")
latest_folder = max(folders, key=os.path.getctime)

rule fetch_data:
	input:
		expand("{outdir}/start.txt", outdir=outdir)
	output:
		expand("{latest_folder}/end.txt", latest_folder=latest_folder)

	resources:
		mem_mb = 10048,
		tmpdir = config["temp_dir"]
	run:
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_fetch_script.py -r all -org 2697049 -db sequences -o {outdir}")
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_fetch_script.py -r all -org 2697049 -db reads -o {config[output_dir]} -of $(ls {config[output_dir]} -rt | tail -n1) && touch {output}")
