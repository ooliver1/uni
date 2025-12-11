#show heading.where(level: 1): set text(20pt)
#show heading.where(level: 2): set text(16pt)
#show heading.where(level: 3): set text(14pt)
#show heading.where(level: 4): set text(12pt)
#set text(10pt)
#page[
  #set align(center)
  Oliver Wilkes
  
  C24057633
  === CM2108 - Secure Communications Networks
  = Portfolio Report
]

== Network Design

My network includes three main areas: a server room and two classrooms. Each area has its own subnet via a switch, all connected to a central router. The server room contains a server and a switch, while each classroom contains several computers and a switch.

The server implements DHCP to assign IP addresses to devices in the classrooms. I decided to make even the wired PCs use DHCP to simplify network management, as static IPs can lead to conflicts and misconfigurations #link(<ref1>)[[1]].

This network is entirely sandboxed from the rest of the university network to prevent any malicious traffic from affecting other users, as students may be testing IoT devices that could be vulnerable to attacks.

== Subnet Design

From the subnet `192.168.0.0/16`, I decided to use the first empty octet to assign a `/8` to each room. This allows for easy identification of which room a device is in, as well as allowing for a large number of devices per room. Each room can have up to $2^8 - 2 = 254$ devices (excluding the switch), which is more than enough for the purposes of this network.

In my network, the server room is assigned the subnet `192.168.0.0/24`, and the two classrooms are assigned `192.168.1.0/24` and `192.168.2.0/24` respectively. These all have the subnet mask `255.255.255.0` which creates a simple network as that is the default mask for many devices.

== Networking Services and Protocols
/*
Explain, using worked through examples, how protocols are used to transfer
data across the above network to perform tasks such as sending an email;
printing a document; uploading files to a server; accessing the network
remotely. Explain encapsulation, referring to protocol header information, and
how this is used to control protocol behaviour, giving worked through examples
of common networking protocols at all seven layers of the OSI 7-layer model.
You may use a packet capture tool such as Wireshark to generate data packets
to use as illustrative examples. All discussion should be related to the scenario,
and while you do not have to implement features in your simulation in order to
include them in the discussion, you should make it clear if you have done so
and show screenshots as evidence. Indicative length – 600 words.
*/

Throughout the network, a variety of protocols are used to ensure data is transferred correctly and efficiently. The OSI 7-layer model provides a framework for for these protocols. Data is encapsulated as it moves through the network, and de-encapsulated at the destination. Each layer adds its own information, allowing for the data to be properly routed and understood.

For example, when sending an email from a computer in Classroom 1 to the server in the Server Room, the following protocols are used at each layer of the OSI model:
7. *Application Layer*: The email client uses the Simple Mail Transfer Protocol (SMTP) to format and send the email. The headers include the sender and recipient addresses.
6. *Presentation Layer*: The email content is encoded in a format such as MIME to ensure it can be properly displayed on the recipient's device.
5. *Session Layer*: SMTP usually uses TLS to establish a secure session between the client and server, ensuring that the data is encrypted and secure.
4. *Transport Layer*: The Transmission Control Protocol (TCP) breaks the email into segments, adding sequence numbers and error-checking information to ensure all segments arrive correctly. The headers include source and destination port numbers to identify the application, 587 is generally used for SMTPS.
3. *Network Layer*: The Internet Protocol (IP) adds source and destination IP addresses to the segments, allowing them to be routed through the network.
2. *Data Link Layer*: The Ethernet protocol encapsulates the IP packets into frames, adding MAC addresses for the source and destination devices on the local network.
1. *Physical Layer*: The frames are converted into electrical signals and transmitted over the physical medium, such as copper cables.

#image("images/smtp.png")

Another example is DHCP, which is used to assign IP addresses to devices on the network. When a device connects to the network, it sends a `DHCPDISCOVER` message to find a DHCP server. The server responds with a `DHCPOFFER` message, which includes an available IP address and other configuration information. The device then sends a `DHCPREQUEST` message to accept the offer, and the server responds with a `DHCPACK` message to confirm the assignment.

Layers 1 and 2 are the same as above, and there is no session or presentation involved with DHCP.

7. *Application Layer*: The client uses the Dynamic Host Configuration Protocol (DHCP) to request and receive IP addresses.
4. *Transport Layer*: UDP adds source and destination port numbers (67 for servers, 68 for clients) to the messages. UDP is used here as the client does not have an IP address yet, so a connection-oriented protocol like TCP cannot be used.
3. *Network Layer*: IP adds source and destination IP addresses to the UDP datagrams. As there is no established connection, the source IP address may be `0.0.0.0`, and the destination IP address is the broadcast address `255.255.255.255`.
2. *Data Link Layer*: Ethernet encapsulates the IP packets into frames with MAC addresses.
1. *Physical Layer*: The frames are transmitted over the physical medium.

#image("images/dhcp.png")

Another important protocol is DNS, which translates human-readable domain names into IP addresses. When a user types a URL into their web browser, the following process occurs:
7. *Application Layer*: The web browser uses the Domain Name System (DNS) protocol to request the IP address associated with the domain name.
4. *Transport Layer*: UDP adds source and destination port numbers (53 for DNS) to the request.
3. *Network Layer*: IP adds source and destination IP addresses to the UDP datagram.
2. *Data Link Layer*: Ethernet encapsulates the IP packets into frames with MAC addresses.
1. *Physical Layer*: The frames are transmitted over the physical medium.

#image("images/dns.png")

== Network Security and Availability

=== Principles of Information Security

/*
Explain how your network upholds the principles of information security,
justifying your choices and evaluating the effectiveness of security controls,
using examples. You should include any additional control measures not
covered in your network design that could mitigate common vulnerabilities as
recommendations but ensure that you highlight any that you have
implemented. Indicative length – 400 words
*/

One of the main principles of information security is confidentiality, which ensures that sensitive information is only accessible to authorised users. One way to uphold this is using VLANs to segment the network, so that devices in one room cannot directly communicate with devices in another room, and stopping testing IoT devices from accessing the server.

Additionally, using strong encryption protocols such as WPA3 for Wi-Fi networks helps protect data in transit from eavesdropping. My network uses WPA2-PSK, but WPA Enterprise mode with 802.1X authentication can be implemented to ensure that only authorised users can connect to the network, and allow for adding and removing users easily, as well as logging their activity. Ethernet connections are also used where possible to reduce the risk of wireless MITM attacks.

Firewalls can be implemented within the network itself when crossing VLANs to control what types of traffic are allowed between segments. For example, only allowing DHCP, DNS, HTTP/S and SSH/SFTP to the server from the classroom, and blocking all other traffic. This limits the attack surface and helps prevent lateral movement in the event of a breach, especially since students may be using traffic sniffing tools.

Integrity is another princple of information security, which ensures that data is not altered or tampered with during transmission. Using protocols such as TLS for web traffic and SSH/SFTP for remote access helps ensure that data is encrypted and cannot be modified without detection. Additionally, implementing checksums and hash functions can help verify the integrity of files and data transfers. This would be useful for students transferring firmware, to ensure that the files have not been corrupted or altered.

If DNS was implemented in the network, DNSSEC could be used to protect against DNS spoofing and cache poisoning attacks, ensuring that users are directed to the correct IP addresses. My network implements DHCP snooping to only allow DHCP packets to be broadcast from authorised servers, preventing rogue DHCP servers from spoofing legitimate ones #link(<ref3>)[[3]].

A big improvement to the security of the network can be made by implementing physical security measures, such as locking server racks and restricting access to authorised personnel only. This helps prevent physical tampering and theft of equipment, which could lead to data breaches or service disruptions.

=== Availability

/*
In relation to the principle of availability, explain how your network upholds
high performance and dependability, using examples of potential issues and
showing how your network could mitigate them. Describe how network
performance and dependability can be measured. You do not have to include
these measures in your simulation but ensure that you highlight any that you
have implemented. Indicative length – 200 words
*/

Availability is the final principle of information security, which ensures that systems and data are accessible to authorised users when needed. The main way this is done in my network is by entirely sandboxing the network from the rest of the university network, ensuring that malicious traffic cannot impact the availability of the rest of the network.

One way to improve the availability in my network is to add DHCP rate limits to the DHCP snooping setup. This helps prevent DHCP starvation attacks, where an attacker floods the DHCP server with requests to exhaust the available IP addresses.

DNS fallover could also be used to maintain availability in the event of a DNS server failure. Power redundancy and regular backups of critical systems and data can also help ensure availability in the event of hardware failures or cyberattacks.

Network performance and dependability can be measured using metrics such as uptime, latency, throughput, and packet loss. Tools such as ping tests, traceroutes, and network monitoring software can be used to measure these metrics and identify potential issues before they impact availability #link(<ref4>)[[4]].

== References

<ref1> [1] #link("https://cloudnewshub.com/?p=183302") "Reduced administrative workload" - Accessed 9th December 2025.

<ref2> [2] #link("https://www.icann.org/resources/pages/dnssec-what-is-it-why-important-2019-03-05-en") "DNS By Itself Is Not Secure" - Accessed 9th December 2025.

<ref3> [3] #link("https://attack.mitre.org/techniques/T1557/003/") "Mitigations" - Accessed 9th December 2025.

<ref4> [4] #link("https://www.cisco.com/site/us/en/learn/topics/networking/what-is-network-monitoring.html") "Types of network monitoring protocols" - Accessed 9th December 2025.
