# Cloud-1: current exercises

> This file is overwritten as you move on. It always shows **what to do now**.
> Roadmap: **1. Ansible basics** → 2. Roles → 3. Docker role → 4. Compose stack → 5. App role → 6. Secrets → 7. Firewall → 8. Tests → 9. Real cloud

## Done ✅
- SSH key login works on the container (`root@172.17.0.3`) and the VM (`vagrant@192.168.56.99`)
- `ansible myhosts -m ping` → 2 × `pong`
- Python interpreter warning removed
- 1.1: shared variables moved to `group_vars/all.yml`
  - small cleanup left: remove the old commented lines in `inventory.ini`; decide if `ansible_connection: ssh` is needed (it's the default)
- 1.2: identified the keys in `authorized_keys` (the comment is only a label; the fingerprint is the real proof)

---

## Step 1: Ansible basics

### Exercise 1.3: your first playbook
Create `playbook.yml` that, on all hosts in `myhosts`:
1. installs the `curl` package (module: `apt`)
2. creates the folder `/opt/test` (module: `file`)

Run it: `ansible-playbook -i inventory.ini playbook.yml`

Things you will run into:
- On the VM you are `vagrant`, not root → look up `become`.
- `apt` may fail if the package list is old → read about the `update_cache` option.

✔ Done when: the playbook runs **2 times** with no errors, and you saved the `PLAY RECAP` of both runs.

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
