See [oid-info.com](http://oid-info.com/get/)
# OIDs meaning - cisco switch
## iso.3.6.1.2.1.1.1
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysDescr(1)}
```
- description
```
sysDescr OBJECT-TYPE
SYNTAX DisplayString (SIZE (0..255))
MAX-ACCESS read-only
STATUS current
DESCRIPTION
"A textual description of the entity. This value should
include the full name and version identification of
the system's hardware type, software operating-system,
and networking software."
```

## iso.3.6.1.2.1.1.2
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysObjectID(2)}
```
- description
```
sysObjectID OBJECT-TYPE
SYNTAX OBJECT IDENTIFIER
MAX-ACCESS read-only
STATUS current
DESCRIPTION
"The vendor's authoritative identification of the
network management subsystem contained in the entity.
This value is allocated within the SMI enterprises
subtree (1.3.6.1.4.1) and provides an easy and
unambiguous means for determining `what kind of box' is
being managed. For example, if vendor `Flintstones,
Inc.' was assigned the subtree 1.3.6.1.4.1.424242,
it could assign the identifier 1.3.6.1.4.1.424242.1.1
to its `Fred Router'."

```

## iso.3.6.1.2.1.1.3
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysUpTime(3)}
```
- description
```
sysUpTime OBJECT-TYPE
SYNTAX TimeTicks
MAX-ACCESS read-only
STATUS current
DESCRIPTION
"The time (in hundredths of a second) since the
network management portion of the system was last
re-initialized."
```

## iso.3.6.1.2.1.1.4
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysContact(4)}
```
- description
```
sysContact OBJECT-TYPE
SYNTAX DisplayString (SIZE (0..255))
MAX-ACCESS read-write
STATUS current
DESCRIPTION
"The textual identification of the contact person for
this managed node, together with information on how
to contact this person. If no contact information is
known, the value is the zero-length string."

```

## iso.3.6.1.2.1.1.5
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysName(5)}
```
- description
```
sysName OBJECT-TYPE
SYNTAX DisplayString (SIZE (0..255))
MAX-ACCESS read-write
STATUS current
DESCRIPTION
"An administratively-assigned name for this managed
node. By convention, this is the node's fully-qualified
domain name. If the name is unknown, the value is
the zero-length string."
```

## iso.3.6.1.2.1.1.6
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysLocation(6)}
```
- description
```
sysLocation OBJECT-TYPE
SYNTAX DisplayString (SIZE (0..255))
MAX-ACCESS read-write
STATUS current
DESCRIPTION
"The physical location of this node (e.g., 'telephone
closet, 3rd floor'). If the location is unknown, the
value is the zero-length string."
```

## iso.3.6.1.2.1.1.7
- ASN.1 notation
```
{iso(1) identified-organization(3) dod(6) internet(1) mgmt(2) mib-2(1) system(1) sysServices(7)}
```
- description
```
sysServices OBJECT-TYPE
SYNTAX INTEGER (0..127)
MAX-ACCESS read-only
STATUS current
DESCRIPTION
"A value which indicates the set of services that this
entity may potentially offer. The value is a sum.
This sum initially takes the value zero. Then, for
each layer, L, in the range 1 through 7, that this node
performs transactions for, 2 raised to (L - 1) is added
to the sum. For example, a node which performs only
routing functions would have a value of 4 (2^(3-1)).
In contrast, a node which is a host offering application
services would have a value of 72 (2^(4-1) + 2^(7-1)).
Note that in the context of the Internet suite of
protocols, values should be calculated accordingly:
layer functionality
1 physical (e.g., repeaters)
2 datalink/subnetwork (e.g., bridges)
3 internet (e.g., supports the IP)
4 end-to-end (e.g., supports the TCP)
7 applications (e.g., supports the SMTP)
For systems including OSI protocols, layers 5 and 6
may also be counted."

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```

## 
- ASN.1 notation
```

```
- description
```

```