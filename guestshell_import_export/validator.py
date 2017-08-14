#!/usr/bin/env python

'''YAML Schema Validation'''

import json
import jsonschema
import ruamel.yaml as yaml
from optparse import OptionParser


def validate_yaml(schema_data, yaml_data, verbose_flag):
    """Validate the YAML data using the schema provided.

    Uses the Draft 4 JSON schema_data provided to validate yaml_data.
    Any errors are reported in stdout.
    """
    v = jsonschema.Draft4Validator(schema_data)
    errors = sorted(v.iter_errors(yaml_data), key=lambda e: e.path)
    if errors:
        for error in errors:
            print("ERROR\n-----------")
            if verbose_flag:
                print(error)
            else:
                print(error.message)
        return False
    return True


def main():
    desc = ("Validate the YAML file used against the provided schema. "
	    "Packages required: json, jsonschema, ruamel.yaml, optparse")
    parser = OptionParser(description=desc,
                          usage="\n%prog schema_file yaml_file")
    parser.add_option("-v", "--verbose", action="store_true",
                      dest="verbose_flag", default=False,
                      help="Show verbose debugs")
    (options, args) = parser.parse_args()

    if len(args) != 2:
        print("Arguments not provided. See -h for help")
        exit()

    schema_file = args[0]
    yaml_file = args[1]

    try:
        f = open(yaml_file)
    except Exception as e:
        print("Could not open file provided: %s" % (e))
        exit()

    try:
        yaml_handle = yaml.YAML(typ='safe')
        yaml_handle.default_flow_style = False
        yaml_data = yaml_handle.load(f)
    except Exception as e:
        print("Failed to load YAML data:")
        print(e)
    finally:
        f.close()

    if options.verbose_flag:
        print("Input YAML data:")
        print("\n***************************************\n")
        print(json.dumps(yaml_data, indent=4))
        print("\n***************************************\n")

    try:
        f = open(schema_file)
    except Exception as e:
        print("Could not open file provided: %s" % (e))
        exit()

    try:
        schema_data = json.load(f)
    except Exception as e:
        print("The JSON Schema file %s could not be parsed:" % (schema_file))
        print(e)
        exit()
    finally:
        f.close()

    if validate_yaml(schema_data, yaml_data, options.verbose_flag) is False:
        print("\nYAML file %s failed schema validation against %s. "
              "Please correct the error(s) above." % (yaml_file, schema_file))
    else:
        print("\nSuccessfully validated YAML file %s" % (yaml_file))

if __name__ == '__main__':
    main()
