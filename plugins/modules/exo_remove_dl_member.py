#!/usr/bin/python
# -*- coding: utf-8 -*-


# Copyright 2020 Colton Hughes <colton.hughes@firemon.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


ANSIBLE_METADATA = {'status': ['stableinterface'],
                    'supported_by': 'community',
                    'version': '1.0'}

DOCUMENTATION = '''
---
module: exo_remove_dl_member
version_added: "2.9.10"
short_description: Removes user from distribution lists
description:
     - The Module removes users from distribution lists which are not exposed in the Microsoft Graph API
options:
  dl_name:
    description:
      - Name of the distribution list to remove the user from
    required: true
  member:
    description:
      - Username to remove from the distribution list (takes UPN)
    required: true
  exo_username:
    description:
      - Username with permission to modify Exchange Transport Rules
    required: true
  exo_password:
    description:
      - Password matching username with permission to modify Exchange Transport Rules
    required: true
author: "Colton Hughes <colton.hughes@firemon.com>"
'''
EXAMPLES = '''
- name: Remove user from the distribution list
  exo_remove_dl_member:
    dl_name: 'Company Distro'
    member: 'john.doe@example.com'
    exo_username: < credentials >
    exo_password: < credentials >
'''
RETURN = '''
distribution_list:
  description: name of the distribution list
  returned: always
  type: string
  sample:
    - company_distro@example.com
member:
  description: User who was removed from distribution list
  returned: changed
  type: string
  sample:
    - john.doe@example.com
'''
