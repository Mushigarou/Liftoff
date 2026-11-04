# Liftoff
- From an empty VM to a live site in one run.

# Architecture: how PHP runs

WordPress is only `.php` files. A PHP interpreter runs them, and a web server speaks HTTP with the browser.

## `wordpress:*-apache`: Apache + mod_php

The PHP interpreter is a module **inside** Apache: one process is both the web server and the interpreter.
nginx forwards everything over HTTP.

```mermaid
flowchart LR
    B["Browser"] -- "HTTP" --> N["nginx<br/>reverse proxy"]
    N -- "HTTP<br/>proxy_pass" --> A
    subgraph WP["container: wordpress (apache)"]
        A["Apache worker<br/>+ mod_php"]
        F[("WordPress files<br/>/var/www/html")]
        A -- "reads + runs .php" --> F
    end
    A -- "SQL :3306" --> DB[("MariaDB")]
```

## `wordpress:*-fpm`: nginx + FastCGI + php-fpm

php-fpm is a PHP interpreter that runs **on its own** and waits on port 9000.
nginx sends `.php` requests to it with the FastCGI protocol, and serves static files (images, CSS, JS) itself,
so both containers need the WordPress files (a shared volume).

```mermaid
flowchart LR
    B["Browser"] -- "HTTP" --> N
    subgraph NG["container: nginx"]
        N["nginx"]
    end
    subgraph WP["container: wordpress (fpm)"]
        P["php-fpm<br/>master + workers"]
    end
    N -- "FastCGI :9000<br/>fastcgi_pass" --> P
    N -- "static files<br/>.jpg .css .js" --> V[("shared volume<br/>WordPress files")]
    P -- "reads + runs .php" --> V
    P -- "SQL :3306" --> DB[("MariaDB")]
```


# References

## Ansible
- [YAML syntax](https://docs.ansible.com/projects/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax)
- [Using variables](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html)
- [Facts and magic variables](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_vars_facts.html)
- [Special variables](https://docs.ansible.com/projects/ansible/latest/reference_appendices/special_variables.html#special-variables)
- [Roles](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_reuse_roles.html)
- [Collection index (modules)](https://docs.ansible.com/projects/ansible/latest/collections/ansible/index.html)
- [Jinja built-in filters](https://jinja.palletsprojects.com/en/stable/templates/#builtin-filters)

## Docker
- [Install Docker Engine on Ubuntu (apt repository)](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

## MariaDB
- [Official Docker image](https://hub.docker.com/_/mariadb)
- [Healthcheck without mysqladmin](https://mariadb.org/mariadb-server-docker-official-images-healthcheck-without-mysqladmin/)
- [Using healthcheck.sh](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh)

## WordPress
- [Server requirements](https://wordpress.org/about/requirements/)
- [Official Docker image](https://hub.docker.com/_/wordpress)
- https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#wp-siteurl


## Nginx
- [Beginner’s Guide](https://nginx.org/en/docs/beginners_guide.html)
- https://hub.docker.com/_/nginx
