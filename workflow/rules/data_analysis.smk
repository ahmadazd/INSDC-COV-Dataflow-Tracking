rule data_analysis:
	input:
		expand("{output_dir}/end.txt", output_dir=config["output_dir"])

	output:
		expand("{latest_folder}/end_final.txt", latest_folder=latest_folder)

	resources:
		mem_mb = 5048,
		tmpdir=config["temp_dir"]

	run:
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_analysis_script.py -f {latest_folder} -db reads -c {config[workflow_dir]}/config/config_credentials.yaml")
		shell("python3 {config[workflow_dir]}/workflow/scripts/data_analysis_script.py -f {latest_folder} -db sequences -c {config[workflow_dir]}/config/config_credentials.yaml && touch {output}")
