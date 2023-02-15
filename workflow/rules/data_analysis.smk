
output_dir = config["output_dir"]
wildcard= f"{output_dir}"
folders = glob.glob(f"{wildcard}/*")
latest_folder = max(folders, key=os.path.getctime)

rule data_analysis:
	input:
		expand("{latest_folder}/end.txt", latest_folder=latest_folder)

	output:
		expand("{latest_folder}/end_final.txt", latest_folder=latest_folder)

	resources:
		mem_mb = 8048,
		tmpdir=config["temp_dir"]

	run:
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_analysis_script.py -f {config[output_dir]}/$(ls {config[output_dir]} -rt | tail -n1) -db reads -c {config[workflow_dir]}/config/config_credentials.yaml")
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_analysis_script.py -f {config[output_dir]}/$(ls {config[output_dir]} -rt | tail -n1) -db sequences -c {config[workflow_dir]}/config/config_credentials.yaml && touch {output}")
