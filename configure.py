#!/usr/bin/env python
# -*- coding: utf-8 -*-

from distutils.util import strtobool
from getpass import getpass
import secrets
import string

from yaml import (
    safe_dump as yaml_safe_dump,
    safe_load as yaml_safe_load,
)

local_envs = {}

DJANGO_SECRET_LENGTH = 50
DJANGO_SECRET_CHARS = string.ascii_letters + string.digits + "!@#$%^&*(-_=+)"


def _blue(text):
    return "\033[94m{}\033[00m".format(text)


def _cyan(text):
    return "\033[96m{}\033[00m".format(text)


def _green(text):
    return "\033[92m{}\033[00m".format(text)


def _purple(text):
    return "\033[95m{}\033[00m".format(text)


def _red(text):
    return "\033[91m{}\033[00m".format(text)


def _yellow(text):
    return "\033[93m{}\033[00m".format(text)


def _header(text):
    return "\033[1;35m{}\033[00m".format(text)


def _italic(text):
    return "\033[97m{}\033[00m".format(text)


def _subheader(text):
    return "\n{}\n".format(_blue(text))


def _write_configuration(envfile_path, configuration):
    with open(envfile_path, "w") as file_resource:
        configuration_content = "\n".join(
            [
                "{}={}".format(_key, configuration[_key])
                for _key in configuration
            ]
        )
        file_resource.write(configuration_content)


def _boolean_input(raw_input, default=False):
    try:
        return strtobool(raw_input.lower())
    except ValueError:
        return default


def services_choices():
    print(_header("Project Name"))
    print("- Ghost")
    print("- Database")

    database_services = [
        "+ {}".format(_yellow("Database")),
        "|- {}".format(_blue("mysql")),
        "|   [3306]",
        "|- {}".format(_blue("adminer")),
        "|   [8080]",
    ]
    ghost_services = [
        "+ {}".format(_yellow("Ghost")),
        "|- {}".format(_blue("app")),
        "|   [2368]",
    ]

    services_display = database_services
    services_display += ghost_services

    print("\n---")
    print("\n".join(services_display))
    print("---\n")


def mysql_configuration():
    print(_subheader("MySQL Configuration"))

    mysql_database = input("Database Name (ghost): ")
    mysql_username = input("Username (root): ")
    mysql_password = getpass("Password (secretpassword): ")
    mysql_hostname = input("Hostname (mysql): ")
    mysql_port = input("Port (3306): ")

    mysql_database = mysql_database if mysql_database else "ghost"
    mysql_username = mysql_username if mysql_username else "root"
    mysql_password = mysql_password if mysql_password else "secretpassword"
    mysql_hostname = mysql_hostname if mysql_hostname else "mysql"
    mysql_port = mysql_port if mysql_port else 3306

    configuration = {
        "MYSQL_DB": mysql_database,
        "MYSQL_USER": mysql_username,
        "MYSQL_PASSWORD": mysql_password,
        "MYSQL_HOSTNAME": mysql_hostname,
        "MYSQL_PORT": mysql_port,
    }
    local_envs.update({"mysql": configuration})

    envfile_path = "mysql/.env"
    _write_configuration(envfile_path, configuration)
    print(_green("\nSave values to {}".format(envfile_path)))


def ghost_configuration():
    print("\n{}\n".format(_blue("Ghost")))

    print(_cyan("\nGlobal"))
    ghost_node_env = input("Node Environment (development): ")
    ghost_base_url = input("Base URL (http://localhost:2368): ")

    ghost_node_env = ghost_node_env if ghost_node_env else "development"
    ghost_base_url = ghost_base_url if ghost_base_url else "http://localhost:2368"  # noqa: E501

    configuration = {
        "NODE_ENV": ghost_node_env,
        "url": ghost_base_url,
        "database__client": "mysql",
        "database__connection__host": local_envs["mysql"]["MYSQL_HOSTNAME"],
        "database__connection__user": local_envs["mysql"]["MYSQL_USER"],
        "database__connection__password": local_envs["mysql"]["MYSQL_PASSWORD"],
        "database__connection__database": local_envs["mysql"]["MYSQL_DB"],
    }

    local_envs.update({"ghost": configuration})

    envfile_path = "app/.env"
    _write_configuration(envfile_path, configuration)
    print(_green("\nSave values to {}".format(envfile_path)))


def main():
    chosen = False

    while not chosen:
        services_choices()
        confirm = input("Confirm [Y/n]: ")
        chosen = _boolean_input(confirm, default=True)
        print("\n")

    mysql_configuration()
    ghost_configuration()


if __name__ == '__main__':
    main()
