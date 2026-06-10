import argparse
import yaml
import json


def prepare_builds(args: argparse.Namespace) -> None:
    source_path: str = args.src

    with open(source_path) as f:
        project = f.read()

    project = project.replace("${PAI_BUILD_VARIANT_SUFFIX}", "")
    project = project.replace("${PAI_BUILD_VERSION_SUFFIX}", "")

    parsed_project = yaml.safe_load(project)

    build_info = []

    services = parsed_project["services"]

    for (srv_name, srv) in services.items():
        if srv_name.endswith("-variant"):
            continue

        build_info.append(
            {
                "variant": srv_name,
                "version": srv["image"].split(":", 1)[1]
            }
        )

    print(json.dumps(build_info))


def main() -> None:
    parser = argparse.ArgumentParser(prog="paictl")
    commands = parser.add_subparsers()
    cmd_create_build_info = commands.add_parser("prepare-builds")
    cmd_create_build_info.add_argument("--src", required=True, action="store")
    cmd_create_build_info.set_defaults(func=prepare_builds)

    parsed_args = parser.parse_args()
    parsed_args.func(parsed_args)


if __name__ == "__main__":
    main()
