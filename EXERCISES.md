# Cloud-1: current exercises

> This file is overwritten as you move on. It always shows **what to do now**.
> Roadmap: **1. Ansible basics** → 2. Roles → 3. Docker role → 4. Compose stack → 5. App role → 6. Secrets → 7. Firewall → 8. Tests → 9. Real cloud

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
- 1.5.## Step 2: Roles

A **role** is a folder with a fixed layout. Ansible knows where to look, so you don't write paths.
Later you will have roles like `docker`, `wordpress`, `firewall`. Today: move your current playbook into one role called `base`.

### Exercise 2.1: your first role
1. Create the skeleton: `ansible-galaxy role init roles/base` (run it in `quick_start/`). Look at the folders it made.
   Delete the ones you don't need (keep `tasks/`, `handlers/`, `templates/`, `defaults/`, `meta/`).
2. Move things into the role:
   - the 4 tasks → `roles/base/tasks/main.yml` (just the list of tasks, no `hosts:`, no `tasks:` key)
   - the handler → `roles/base/handlers/main.yml`
   - `info.txt.j2` → `roles/base/templates/` and change `src:` to just `info.txt.j2`
   - the `packages` list → `roles/base/defaults/main.yml` (remove it from `group_vars/all.yml`)
3. Your `playbook.yml` becomes very short: `hosts: myhosts` + `roles: [base]`.
4. Give the handler a name that says **what it does** (e.g. `Print info.txt changed`). Real handlers are named like `Restart nginx`.

✔ Done when:
- the playbook runs with no errors, and run 2 → `changed=0`
- `ansible-lint` passes
- you can say why `packages` goes in `defaults/` and not in `vars/` (hint: look at the precedence list, which one is easy to override from `group_vars`?)

### Exercise 2.2: override a default
1. Add `htop` **only for the VM**: create `host_vars/192.168.56.99.yml` with a `packages` list that has `htop` too.
2. Run the playbook.
   Watch out: a list in `host_vars` **replaces** the default list, it does not add to it. What happens to `curl`, `git`, `iproute2`?

✔ Done when: `htop` is installed on the VM but **not** on `cloud1` (check with `ansible myhosts -m ansible.builtin.package_facts` or `-a 'which htop'`).

---

).
2. Run the playbook **once**.

✔ Done when: run 1 passes with no errors on the new container, and run 2 → `changed=0`.
Bonus: try `ansible-playbook -i inventory.ini playbook.yml --check --diff` (dry run: shows what *would* change).

---

## Questions for your defense
Answer them in your own words. Writing the answers down helps a lot.

1. Why is it safe to copy a `.pub` key to a server, but never the private key?
2. Why does Ansible need Python on the **server**, but no agent?
3. Compare `changed=` in run 1 and run 2 of your playbook. Why are they different? What is **idempotence**?
4. Your own key or Vagrant's key: which one fits this project better, and why? (Remember: a real cloud server has no Vagrant.)
5. `ansible_connection=docker` vs SSH: what is the difference?
6. How do you **prove** a key in `authorized_keys` is yours? (Hint: `ssh-keygen -lf`, so why is the comment not enough?)
7. `group_vars/all.yml` vs `group_vars/myhosts.yml`: what is the difference?
8. `group_vars/all.yml` says `ansible_connection: ssh`, but `cloud1` uses docker. Why does the inventory line win? (Look up "variable precedence".)
9. A handler runs only when something changed. Why is that useful? (Think: restarting nginx on every run.) When does it run: right after the task, or at the end?
10. Where do `ansible_distribution` and friends come from? What does "Gathering Facts" do?
11. Facts vs magic variables vs connection variables: where does each one come from? Why is `ansible_facts['inventory_hostname']` an error?
12. Why did `cloud1` have no `default_ipv4` even after `iproute2` was installed in the same run?
13. `ansible myhosts -a 'cat /opt/test/info.txt'` says `CHANGED`, but nothing changed. Why? Why do playbooks prefer real modules over `command`/`shell`?
14. What is the difference between `defaults/main.yml` and `vars/main.yml` in a role?
15. Why use roles at all, if one big playbook also works?
