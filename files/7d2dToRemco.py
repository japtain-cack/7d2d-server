#!/usr/bin/env python3

import xml.etree.ElementTree as ET

tree = ET.parse('serverconfig.xml')
root = tree.getroot()
data = ''

for item in root.iter('property'):
    new_value = f'{{{{ getv("/sevend2d/{item.attrib["name"].lower()}", "{item.attrib["value"]}") }}}}'
    item.attrib['value'] = new_value

tree.write('serverconfig.xml.new', encoding="utf-8", xml_declaration=True)

with open('serverconfig.xml.new', 'r') as fh:
    for line in fh:
        data += line.replace('&quot;', '"')
        print(data)

with open('serverconfig.xml.new', 'w') as fh:
    fh.write(data)

