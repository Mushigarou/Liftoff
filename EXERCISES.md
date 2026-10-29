# Cloud-1: current exercises

> This file is overwritten as you move on. It always shows **what to do now**.
> Roadmap: 1. Ansible basics → 2. Roles → **3. Docker role** → 4. Compose stack → 5. App role → 6. Secrets → 7. Firewall → 8. Tests → 9. Real cloud

> 📅 **Pace checkpoint ~Oct 30–31:** check progress since Oct 28, then choose: keep the full plan, or go faster with focus on what cloud-1 needs.

## Done ✅
- SSH key login works on the VM (`vagrant@192.168.56.99`)
- `ansible myhosts -m ping` → 2 × `pong`
- Python interpreter warning removed
- 1.1: shared variables moved to `group_vars/all.yml`
- 1.2: identified the keys in `authorized_keys` (the comment is only a label; the fingerprint is the real proof)
- Container fixed after restart (2026-10-25): switched to `cloud1 ansible_connection=docker`
  (name instead of IP → it survives restarts; no sshd needed)
- 1.3: first playbook (`curl` + `/opt/test`), idempotent: run 2 → `changed=0` on both hosts
  - `become` set once per host in the inventory (`ansible_become=true` on the VM; cloud1 is already root and has no sudo)
- 1.4: `ansible-lint playbook.yml` passes (0 failures, `production` profile)
- 1.5.1: one `apt` task installs the `packages` list (`curl`, `git`, `iproute2`), with `cache_valid_time: 3600` (seconds)
- 1.5.2: template `info.txt.j2` deployed on both hosts (2026-10-25), run 2 → `changed=0`
  - **facts** live in `ansible_facts['x']` with **no** `ansible_` prefix (`distribution`, `default_ipv4`)
  - **magic vars** (`inventory_hostname`) and **connection vars** (`ansible_user`) are top-level, never in `ansible_facts`
  - `{{ 'inventory_hostname' }}` with quotes = a plain string, not a variable
  - cloud1 had no network facts: `setup` needs the `ip` command → installed `iproute2`, then re-ran `setup` (facts are a snapshot taken at the start of the play)
- 1.5.3: handler + `debug`; dry run with `--check --diff`
- 2.1 (2026-10-29): role `roles/base` (tasks, handlers, templates, defaults, meta); playbook is just `roles: [base]`; lint passes
  - role variables have the role name as prefix: `base_packages`, `base_extra_packages`
  - connection settings are **not** role settings: `interpreter_python` moved to `ansible.cfg`, `ansible_connection: ssh` deleted (it is the default)
  - inventory host renamed `192.168.56.99` → `server` (`ansible_host=` keeps the IP)
- 2.2 (2026-10-29): `htop` only on `server` via `host_vars/server.yml` → `base_extra_packages`
  - pattern: default list + empty "extra" list, so a host **adds** packages instead of **replacing** the list
  - tested the right way: removed htop first (`state=absent`), saw `which htop` fail, then the playbook said `changed: [server]`, `ok: [cloud1]`; run 2 → `changed=0`
- Cleanups: `ansible.cfg` trimmed to 3 lines with a relative `inventory` path; role `meta` and `README` filled in

---

## Step 3: Docker role

cloud-1 runs WordPress, MariaDB and phpMyAdmin in containers. So the server needs **Docker Engine + the compose plugin**.
You will write a second role, `docker`, that installs it the way the official Docker docs say.
Read this page first: https://docs.docker.com/engine/install/ubuntu/ (section "Install using the apt repository").
Your job is to turn each shell command on that page into an Ansible task.

### Exercise 3.1: groups, and why Docker only goes on `server`
`cloud1` is itself a Docker container. Docker *inside* a container needs special settings (`--privileged`) and there is no `systemd` to start the daemon. So: Docker goes on `server` only.

1. In `inventory.ini`, add a new group `[web]` that contains only `server`.
   (A host can be in many groups. `server` stays in `myhosts` too.)
2. In `playbook.yml`, add a **second play**: `hosts: web`, `roles: [docker]`. The first play (base on `myhosts`) stays as it is.
3. Check: `ansible web --list-hosts` and `ansible myhosts --list-hosts`.

✔ Done when: `web` lists only `server`, `myhosts` lists both.

### Exercise 3.2: the `docker` role
Create `roles/docker` (same folders as `base`). Tasks, in this order:

1. **Remove conflicting packages** (`docker.io`, `docker-compose`, `podman-docker`, `containerd`, `runc`): one `apt` task with `state: absent`.
   They come from Ubuntu's repo and fight with Docker's own packages.
2. **Add Docker's apt repository.** Use the module `ansible.builtin.deb822_repository`. Read its doc page (`ansible-doc ansible.builtin.deb822_repository`). You need:
   - `uris`: `https://download.docker.com/linux/ubuntu`
   - `suites`: the Ubuntu codename (`noble` on your VM). **Don't write `noble` by hand:** find the fact that has it (hint: `ansible server -m setup -a 'filter=*release*'`).
   - `components`: `stable`
   - `signed_by`: look at what this option accepts. It can take the GPG key URL directly: `https://download.docker.com/linux/ubuntu/gpg`.
3. **Install** `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`.
   Put this list in `roles/docker/defaults/main.yml` as `docker_packages`.
   Think: apt doesn't know the new repo yet. Which `apt` option fixes that?
4. **Start Docker now and at every boot**: `ansible.builtin.service` (or `systemd_service`) with `state` + `enabled`.

✔ Done when:
- `ansible web -a 'docker run --rm hello-world'` prints "Hello from Docker!"
- `ansible web -a 'docker compose version'` prints a version
- run 2 → `changed=0` on both hosts
- `ansible-lint` passes
- `cloud1` was **not** touched by the docker play (check the recap)

### Exercise 3.3 (bonus): prove it survives a reboot
1. `vagrant reload` (restarts the VM)
2. `ansible web -a 'systemctl is-active docker'`. What does it say? Which line of your role made this happen?

---

---

Questions for your defense: see `QUESTIONS.md` (local only, ignored by git).
