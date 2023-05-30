#!/bin/bash
# Get Ansible Vault password from macOS Keychain
#
# You will need to create a new password item in the login keychain
# See https://blog.sandipb.net/2021/09/24/using-mac-keychain-to-store-and-retrieve-ansible-vault-passwords/

SECURITY_BIN=$(which security)


set_vault_account() {
    if [[ ! -z "$ANSIBLE_VAULT" ]]; then
        account_name="$ANSIBLE_VAULT"
    else

        current_path="$(pwd)"

        # Use current path to set the account used for lookup in system keychain
        case "$current_path" in
            *XYZ* )
                account_name="ansible_xyz_vault"
                ;;

            *ABC* )
                account_name="ansible_abc_vault"
                ;;

            *homelab* )
                account_name="ansible_homelab_vault"
                ;;

            * )
                account_name="ansible_vault"
                ;;
        esac

    fi
}


get_vault_key() {
    $SECURITY_BIN find-generic-password -a $account_name -w
}


set_vault_account
get_vault_key
