Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94A5BD3F
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Jul 2019 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGANrh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Jul 2019 09:47:37 -0400
Received: from mail-eopbgr780070.outbound.protection.outlook.com ([40.107.78.70]:12254
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727397AbfGANrg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Jul 2019 09:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantum.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xln36aBy8c5KFxW1Z61086pTk9JYZyOIE7Hq9ZWyK7o=;
 b=Xi9MHs8LuBOpld3NSy+1+kGvrOyQXO4jnXS7X4z28nwtUwnmSgWCfpqjSpjOE5hTUu0DMqbBP7k+QedUn4IjVbyIttZNrLuLReO7Q4tqs2ciN+Ge5JEgfiXecgbrrbEWrzLO9u1tXiDE+5xSiH3nrWKjvT6KCkBpRRTrc2bDHf8=
Received: from BYAPR14MB2776.namprd14.prod.outlook.com (20.178.196.154) by
 BYAPR14MB3158.namprd14.prod.outlook.com (20.179.158.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 13:47:32 +0000
Received: from BYAPR14MB2776.namprd14.prod.outlook.com
 ([fe80::183c:86b5:f0d6:8e29]) by BYAPR14MB2776.namprd14.prod.outlook.com
 ([fe80::183c:86b5:f0d6:8e29%5]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 13:47:31 +0000
From:   Don Doerner <Don.Doerner@Quantum.Com>
To:     Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: RE: I/O Reordering: Cache -> Backing Device
Thread-Topic: I/O Reordering: Cache -> Backing Device
Thread-Index: AdUt/B/EabqHZCkOQoe8heP9RPaOEABt+p+AABfQlWA=
Date:   Mon, 1 Jul 2019 13:47:31 +0000
Message-ID: <BYAPR14MB277641CB1C17C53346C8FDD5FCF90@BYAPR14MB2776.namprd14.prod.outlook.com>
References: <BYAPR14MB27766E20D92C2A07217C2DF9FCFC0@BYAPR14MB2776.namprd14.prod.outlook.com>
 <d06e4a83-c314-46b7-72ea-97e455acd69f@suse.de>
In-Reply-To: <d06e4a83-c314-46b7-72ea-97e455acd69f@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Don.Doerner@Quantum.Com; 
x-originating-ip: [146.174.244.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27f63c71-0d8e-4884-b0c8-08d6fe2aaa34
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR14MB3158;
x-ms-traffictypediagnostic: BYAPR14MB3158:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR14MB3158063A94EE636E39A91BF8FCF90@BYAPR14MB3158.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(13464003)(199004)(189003)(14444005)(5024004)(3846002)(6116002)(55016002)(6436002)(486006)(256004)(476003)(11346002)(446003)(25786009)(76116006)(6306002)(45080400002)(33656002)(186003)(9686003)(26005)(66066001)(86362001)(316002)(14454004)(7736002)(74316002)(305945005)(5660300002)(7696005)(102836004)(478600001)(81166006)(81156014)(8676002)(68736007)(8936002)(99286004)(53936002)(6916009)(76176011)(52536014)(53546011)(6506007)(66446008)(66556008)(64756008)(4326008)(229853002)(71200400001)(71190400001)(6246003)(72206003)(66476007)(73956011)(66946007)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR14MB3158;H:BYAPR14MB2776.namprd14.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: Quantum.Com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v8sTebhbq7/XRwCcw80wVgaArlwYbt/YeYvzDJ2Z9Mal6qalJflC5Hq746ZSNg7YhXmBDYYku/Pho2q9aLvgZPyfFqUdy6xLyloqzWhqb/M3UQ6rAw2fLFES9Sa3s73CUtdQo1T0O0rDqyyoP7T448cCIww2t2837QJfekXK9alxsn8HbDDgD83Hrk2k2NrGc4TuRdZqYLyGxbOzD5xRPq7URuMnAK/c+PoPonfV4PYRaEwrPAn0q/sxKrab/+OGzDoB7ksyC/E8zCQbubrmkd99RDyvqE4uJFbKB1v7Jz0BYdoC+rgJHEZD7nRmtTpEAqGVVrK9p0Y5hlrLqDX6mq/jSyWOgEpwbnxtqDc7R6ysFQ+mCQcUEOSG1o0sE2nddfXLGCd+ojylSpUJuoh+kcj0Fi+TotyieiAnFwnU184=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f63c71-0d8e-4884-b0c8-08d6fe2aaa34
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 13:47:31.2477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 322a135f-14fb-4d72-aede-122272134ae0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Don.Doerner@Quantum.Com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR14MB3158
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

SSBoYWRuJ3QgcmVhbGx5IHJlYWxpemVkIGZvbGtzIHdlcmUgYWN0aXZlbHkgd29ya2luZyB0aGlz
IGNvbXBvbmVudC4uLiB0aW1lIGZvciBtZSB0byBsb29rIGF0IHRoZSBjb2RlIGFuZCBzZWUgaWYg
SSBjYW4gY29udHJpYnV0ZSBhbnl0aGluZyBoZXJlLi4uDQpUaGFua3MgQ29seSwNCi1kb24tDQoN
Ci0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBsaW51eC1iY2FjaGUtb3duZXJAdmdl
ci5rZXJuZWwub3JnIDxsaW51eC1iY2FjaGUtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhh
bGYgT2YgQ29seSBMaQ0KU2VudDogU3VuZGF5LCAzMCBKdW5lLCAyMDE5IDE5OjI0DQpUbzogRG9u
IERvZXJuZXIgPERvbi5Eb2VybmVyQFF1YW50dW0uQ29tPg0KQ2M6IGxpbnV4LWJjYWNoZUB2Z2Vy
Lmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBJL08gUmVvcmRlcmluZzogQ2FjaGUgLT4gQmFja2lu
ZyBEZXZpY2UNCg0KT24gMjAxOS82LzI5IDU6NTYg5LiK5Y2ILCBEb24gRG9lcm5lciB3cm90ZToN
Cj4gSGVsbG8sDQo+IEknbSBhbHNvIGludGVyZXN0ZWQgaW4gdXNpbmcgYmNhY2hlIHRvIGZhY2ls
aXRhdGUgc3RyaXBlIHJlLWFzcyd5IGZvciB0aGUgYmFja2luZyBkZXZpY2UuICBJJ3ZlIGRvbmUg
c29tZSBleHBlcmltZW50cyB0aGF0IGRvdmV0YWlsIHdpdGggc29tZSBvZiB0aGUgdHJhZmZpYyBv
biB0aGlzIG1haWxpbmcgbGlzdC4gIFNwZWNpZmljYWxseSwgaW4gdGhpcyBtZXNzYWdlIChodHRw
czovL25hbTA1LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0El
MkYlMkZ3d3cuc3Bpbmljcy5uZXQlMkZsaXN0cyUyRmxpbnV4LWJjYWNoZSUyRm1zZzA3NTkwLmh0
bWwmYW1wO2RhdGE9MDIlN0MwMSU3Q0Rvbi5Eb2VybmVyJTQwcXVhbnR1bS5jb20lN0NhZmE1MGRk
MDRhOTE0Zjc2YmI3ODA4ZDZmZGNiMzM4YiU3QzMyMmExMzVmMTRmYjRkNzJhZWRlMTIyMjcyMTM0
YWUwJTdDMSU3QzAlN0M2MzY5NzU0NDY1Mjk1MDIwNjkmYW1wO3NkYXRhPW5DM0poUEwlMkZDNkI1
N3V3NHhqRWtHblY0OGpkOURxSExmME1RTDdBQUVycyUzRCZhbXA7cmVzZXJ2ZWQ9MCksIEVyaWMg
c3VnZ2VzdGVkICIuLi50dXJuaW5nIHVwIC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUvd3JpdGVi
YWNrX3BlcmNlbnQuLi4iIHRvIGluY3JlYXNlIHRoZSBjb250aWd1b3VzIGRhdGEgaW4gdGhlIGNh
Y2hlLg0KPiBNeSBSQUlELTYgaGFzIGEgc3RyaXBlIHNpemUgb2YgMi41TWlCLCBhbmQgaXRzIGJj
YWNoZSdlZCB3aXRoIGEgZmV3IGh1bmRyZWQgR0Igb2YgTlZNZSBzdG9yYWdlLiAgSGVyZSdzIG15
IGV4cGVyaW1lbnQ6DQo+ICogSSBtYWRlIHRoZSBjYWNoZSBhIHdyaXRlIGJhY2sgY2FjaGU6IGVj
aG8gd3JpdGViYWNrID4NCj4gL3N5cy9ibG9jay9iY2FjaGUwL2JjYWNoZS9jYWNoZV9tb2RlDQo+
ICogSSBwbHVnZ2VkIHRoZSBjYWNoZTogZWNobyAwID4NCj4gL3N5cy9ibG9jay9iY2FjaGUwL2Jj
YWNoZS93cml0ZWJhY2tfcnVubmluZw0KPiAqIEkgdXNlIGEgcGF0aG9sb2dpY2FsIEkvTyBwYXR0
ZXJuLCBnZW5lcmF0ZWQgd2l0aCAnZmlvJzogZmlvIC0tYnM9MTI4SyAtLWRpcmVjdD0xIC0tcnc9
cmFuZHdyaXRlIC0taW9lbmdpbmU9bGliYWlvIC0taW9kZXB0aD0xIC0tbnVtam9icz0xIC0tc2l6
ZT00MEcgLS1uYW1lPS9kZXYvYmNhY2hlMC4gIEkgbGV0IGl0IHJ1biB0byBjb21wbGV0aW9uLCBh
dCB3aGljaCBwb2ludCBJIGJlbGlldmUgSSBzaG91bGQgaGF2ZSA0MCBHaUIgb2Ygc2VxdWVudGlh
bCBkaXJ0eSBkYXRhIGluIGNhY2hlLCBidXQgbm90IHB1dCB0aGVyZSBzZXF1ZW50aWFsbHkuICBJ
biBlc3NlbmNlLCBJIHNob3VsZCBoYXZlIH4xNksgY29tcGxldGUgc3RyaXBlcyBzaXR0aW5nIGlu
IHRoZSBjYWNoZSwgd2FpdGluZyB0byBiZSB3cml0dGVuLg0KPiAqIEkgc2V0IHN0dWZmIHVwIHRv
IGdvIGxpa2UgYSBiYXQ6IGVjaG8gMCA+DQo+IC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUvd3Jp
dGViYWNrX3BlcmNlbnQ7IGVjaG8gMCA+DQo+IC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUvd3Jp
dGViYWNrX2RlbGF5OyBlY2hvIDIwOTcxNTIgPg0KPiAvc3lzL2Jsb2NrL2JjYWNoZTAvYmNhY2hl
L3dyaXRlYmFja19yYXRlDQo+ICogQW5kIEkgdW5wbHVnZ2VkIHRoZSBjYWNoZTogZWNobyAxID4N
Cj4gL3N5cy9ibG9jay9iY2FjaGUwL2JjYWNoZS93cml0ZWJhY2tfcnVubmluZw0KPiBJIHRoZW4g
d2F0Y2hlZCAnaW9zdGF0JywgYW5kIHNhdyB0aGF0IHRoZXJlIHdlcmUgbG90cyBvZiByZWFkIG9w
ZXJhdGlvbnMgKHN0YXRpc3RpY2FsbHksIGFmdGVyIG1lcmdpbmcsIGFib3V0IDEgcmVhZCBmb3Ig
ZXZlcnkgNyB3cml0ZXMpIC0gbW9yZSB0aGFuIEkgaGFkIGV4cGVjdGVkLi4uIHRoYXQncyBlbm91
Z2ggdGhhdCBJIGNvbmNsdWRlZCBpdCB3YXNuJ3QgYnVpbGRpbmcgZnVsbCBzdHJpcGVzLiAgSXQg
a2luZGEgbG9va3MgbGlrZSBpdCdzIHBsYXlpbmcgYmFjayBhIGpvdXJuYWwgc29ydGVkIGluIHRp
bWUgdGhlbiBMQkEsIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuLi4NCj4gQW55IHN1Z2dlc3Rpb25z
IGZvciBpbXByb3ZpbmcgKHJlZHVjaW5nKSB0aGUgcmF0aW8gb2YgcmVhZHMgdG8gd3JpdGVzIHdp
bGwgYmUgZ3JhdGVmdWxseSBhY2NlcHRlZCENCg0KSGkgRG9uLA0KDQpJZiB0aGUgYmFja2luZyBk
ZXZpY2UgaGFzIGV4cGVuc2l2ZSBzdHJpcGUgY29zdCwgdGhlIHVwcGVyIGxheWVyIHNob3VsZCBp
c3N1ZSBJL09zIHdpdGggc3RyaXBlIHNpemUgYWxpZ25tZW50LCBvdGhlcndpc2UgYmNhY2hlIGNh
bm5vdCB0byB0b28gbXVjaCB0byBtYWtlIHRoZSBJL08gdG8gYmUgc3RyaXBlIG9wdGltaXplZC4N
Cg0KQW5kIHlvdSBhcmUgcmlnaHQgdGhhdCBiY2FjaGUgZG9lcyBub3Qgd3JpdGViYWNrIGluIHJl
c3RyaWN0IExCQSBvcmRlciwgdGhpcyBpcyBiZWNhdXNlIHRoZSBpbnRlcm5hbCBidHJlZSBpcyB0
cmVuZCB0byBiZSBhcHBlbmRlZCBvbmx5LiBUaGUgTEJBIG9yZGVyaW5nIHdyaXRlYmFjayBoYXBw
ZW5zIGluIGEgcmVhc29uYWJsZSBzbWFsbCByYW5nZSwgbm90IGluIHdob2xlIGNhY2hlZCBkYXRh
LCBzZWUgY29tbWl0IDZlNmNjYzY3YjljNyAoImJjYWNoZTogd3JpdGViYWNrOiBwcm9wZXJseSBv
cmRlciBiYWNraW5nIGRldmljZSBJTyIpLg0KDQpBbmQgSSBhZ3JlZSB3aXRoIHlvdSBhZ2FpbiB0
aGF0ICJpbXByb3ZpbmcgKHJlZHVjaW5nKSB0aGUgcmF0aW8gb2YgcmVhZHMgdG8gd3JpdGVzIHdp
bGwgYmUgZ3JhdGVmdWxseSBhY2NlcHRlZCIuIEluZGVlZCBub3Qgb25seSByZWR1Y2luZyByZWFk
cyB0byB3cml0ZXMgcmF0aW8sIGJ1dCBhbHNvIGluY3JlYXNlIHRoZSByZWFkcyB0byB3cml0ZXMg
dGhyb3VnaHB1dC4gVGhpcyBpcyBzb21ldGhpbmcgSSB3YW50IHRvIGltcHJvdmUsIGFmdGVyIEkg
dW5kZXJzdGFuZCB3aHkgdGhlIHByb2JsZW0gZXhpc3RzIGluIGJjYWNoZSB3cml0ZWJhY2sgY29k
ZSAuLi4NCg0KVGhhbmtzLg0KDQotLQ0KDQpDb2x5IExpDQpUaGUgaW5mb3JtYXRpb24gY29udGFp
bmVkIGluIHRoaXMgdHJhbnNtaXNzaW9uIG1heSBiZSBjb25maWRlbnRpYWwuIEFueSBkaXNjbG9z
dXJlLCBjb3B5aW5nLCBvciBmdXJ0aGVyIGRpc3RyaWJ1dGlvbiBvZiBjb25maWRlbnRpYWwgaW5m
b3JtYXRpb24gaXMgbm90IHBlcm1pdHRlZCB1bmxlc3Mgc3VjaCBwcml2aWxlZ2UgaXMgZXhwbGlj
aXRseSBncmFudGVkIGluIHdyaXRpbmcgYnkgUXVhbnR1bS4gUXVhbnR1bSByZXNlcnZlcyB0aGUg
cmlnaHQgdG8gaGF2ZSBlbGVjdHJvbmljIGNvbW11bmljYXRpb25zLCBpbmNsdWRpbmcgZW1haWwg
YW5kIGF0dGFjaG1lbnRzLCBzZW50IGFjcm9zcyBpdHMgbmV0d29ya3MgZmlsdGVyZWQgdGhyb3Vn
aCBzZWN1cml0eSBzb2Z0d2FyZSBwcm9ncmFtcyBhbmQgcmV0YWluIHN1Y2ggbWVzc2FnZXMgaW4g
b3JkZXIgdG8gY29tcGx5IHdpdGggYXBwbGljYWJsZSBkYXRhIHNlY3VyaXR5IGFuZCByZXRlbnRp
b24gcmVxdWlyZW1lbnRzLiBRdWFudHVtIGlzIG5vdCByZXNwb25zaWJsZSBmb3IgdGhlIHByb3Bl
ciBhbmQgY29tcGxldGUgdHJhbnNtaXNzaW9uIG9mIHRoZSBzdWJzdGFuY2Ugb2YgdGhpcyBjb21t
dW5pY2F0aW9uIG9yIGZvciBhbnkgZGVsYXkgaW4gaXRzIHJlY2VpcHQuDQo=
