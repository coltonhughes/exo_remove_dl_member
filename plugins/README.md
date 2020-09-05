# Module Documentation
This module is quite simple.
It appends or replaces the recipients on the an Exchange Online transport rule.

## Example
```
- name: Add 'john.doe@example.com' to an Exchange Online Rule
  exo_userbounce:
    rule_name: "Test Rule to disable email for user"
    user_email: john.doe@example.com
    mode: append
    condition: sentTo
    exo_username: globaladmin@domain.onmicrosoft.com
    exo_password: P@ssw0rd!
```
This is a very simple module that I put very little effort in perfecting.  If issues arise feel free to open them or fork and modify at your own discretion.