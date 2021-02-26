Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2582325F8C
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Feb 2021 09:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZI72 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Feb 2021 03:59:28 -0500
Received: from mout.gmx.net ([212.227.15.19]:53357 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBZI7Y (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Feb 2021 03:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614329868;
        bh=DQZK+SKB5UpaJuogCw659w5xNnCVIQ7TuGNT0RyaXQE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=F9j1oVDDwa2gImF+n6i+eJ3G+RpVMBac3pCbx9q3MbSlZUsuJsi+KCjYMVpnr184N
         ZEvpryl0NLUJfqN5oqo6MocIwb00K/7HW99dENVwg20birm6yhtROB0cEPX1eNsr7x
         oN8z9atuyDDzXpk3n6F1BP9hORRXQYjRg1SIqeZ4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MTzf6-1lOwtV44d0-00R0wL; Fri, 26
 Feb 2021 09:57:48 +0100
Subject: Re: Large latency with bcache for Ceph OSD
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
 <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
 <07bcb6c8-21e1-11de-d1f0-ffd417bd36ff@gmx.com>
 <cfe2746f-18a7-a768-ea72-901793a3133e@gmx.com>
 <96daa0bf-c8e1-a334-14cb-2d260aed5115@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <b808dde3-cb58-907b-4df0-e0eb2938b51e@gmx.com>
Date:   Fri, 26 Feb 2021 16:57:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <96daa0bf-c8e1-a334-14cb-2d260aed5115@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Language: en-US
X-Provags-ID: V03:K1:DqjX0Zhs7AJrm6z6oH//crTbSP7f4b7UDpLTPbqjeTIuyTl7tZg
 /HPuc4wJ/VxIoSR1LtVRXdaPccg8AjwK4ec9mXxPY89Kdfq2EBz5HqfTl7EiwMLqEfe16mk
 1LAJ67zprAF2u4GxqUBHXRvTo/4ps24YM6j2t1tsph+m82NVWd1AzHt2BANIX6IgiuR+TBB
 azYeHpTiBfiUQNYNKrn+g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BdV0JTjCN4Q=:uNQWn2XYP06c3VClHAK/Bz
 iM6F0QkggWEVJN2C8CZ9nnFVA7U2oEyPKzcmEavHCh7FY3FnSezGtVhiBQX0OYdFGGBn1kIDJ
 zhWwr4rSe+oy6wSuUXo4VLwDYUu3JFqBQgrQ3b5arurU08aZxWm1EOgIEIw8blTsAnkQ9whOL
 TFkXGJZlofoza2a2h8DFHdPh8wFiHPHA2ed3OMqXAZhhUjMj1LgTLf4NM1mluA6vTk0E468V1
 kAf6ldQdHmQrvG6hq8IRq738Z66OM13tHweU6LHy8/V+ttZdAWQqmCXE1Qos9mgaXEBX4CDqZ
 ecZlfXbJNtvVCp3SfkCOIa0agp0QUY9+NYeuDtmulKqjPJraI3+hMik3KXJ3H5bUlOiWIlJMk
 Su/inauZtfj8GcRpEspf1u05QJRnR7iouOT7bYvtDa0GyUdNHOBqKz8y8dVXltlUzEvfXkC8v
 2KmequszrY88G/Bpar1Z60GXxGuYLXX2ERQ54yZuM3EdnITNAwyfggqNVBfLkR0jnJZJ+QW3f
 FrVL2H0RquoI+wc3Ln1b9nZsHOp9afVNEIYa17DCKLOPJ4PBRW8gwShj9xWavyuF6qJgZaHf2
 +jirYqbDAanmgLD2aoTdaewsbCQIVuKSAVIninSdKqDy8bBDC1OCLZTO7L1h0jOjjxwG29HWB
 CfZrG7UoBKHlumocfDAYh2RGcxEAF/knoz7buH2Sc+FbA0dG3inh0xnsrtRzDqFIwEpJGpVia
 6RQcJnlUZjg8ptm0YL6/bsGht0AtCyJUbAXniyqKsJkhUkHvjHyauH3ceDXVVgfI5zWyzlEhb
 yeMqobvgRDHGLirvbI91eFPfxZSW0K18fYcNwgRE9oyxeCZo1v872fohFJp8CRIM/op8T38IZ
 2wupdjyfytEg/f5lK99w==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQpPbiAyMDIxLzIvMjUg5LiL5Y2IMTA6NDQsIENvbHkgTGkgd3JvdGU6DQo+IE9uIDIvMjUvMjEg
OTowMCBQTSwgTm9ybWFuLktlcm4gd3JvdGU6DQo+PiBJIG1hZGUgYSB0ZXN0Og0KPiBCVFcsIHdo
YXQgaXMgdGhlIHZlcnNpb24gb2YgeW91ciBrZXJuZWwsIGFuZCB5b3VyIGJjYWNoZS10b29sLCBh
bmQgd2hpY2gNCj4gZGlzdHJpYnV0aW9uIGlzIHJ1bm5pbmcgPw0Kcm9vdEBXWFMwMTA2On4jIHVu
YW1lIC1hDQpMaW51eCBXWFMwMTA2IDUuNC4wLTU4LWdlbmVyaWMgIzY0fjE4LjA0LjEtVWJ1bnR1
IFNNUCBXZWQgRGVjIDkgMTc6MTE6MTEgVVRDIDIwMjAgeDg2XzY0IHg4Nl82NCB4ODZfNjQgR05V
L0xpbnV4DQpyb290QFdYUzAxMDY6fiMgY2F0IC9ldGMvb3MtcmVsZWFzZQ0KTkFNRT0iVWJ1bnR1
Ig0KVkVSU0lPTj0iMTYuMDQgTFRTIChYZW5pYWwgWGVydXMpIg0KSUQ9dWJ1bnR1DQpJRF9MSUtF
PWRlYmlhbg0KUFJFVFRZX05BTUU9IlVidW50dSAxNi4wNCBMVFMiDQpWRVJTSU9OX0lEPSIxNi4w
NCINCkhPTUVfVVJMPSJodHRwOi8vd3d3LnVidW50dS5jb20vIg0KU1VQUE9SVF9VUkw9Imh0dHA6
Ly9oZWxwLnVidW50dS5jb20vIg0KQlVHX1JFUE9SVF9VUkw9Imh0dHA6Ly9idWdzLmxhdW5jaHBh
ZC5uZXQvdWJ1bnR1LyINClVCVU5UVV9DT0RFTkFNRT14ZW5pYWwNCnJvb3RAV1hTMDEwNjp+IyBk
cGtnIC1sIGJjYWNoZS10b29scw0KRGVzaXJlZD1Vbmtub3duL0luc3RhbGwvUmVtb3ZlL1B1cmdl
L0hvbGQNCnwgU3RhdHVzPU5vdC9JbnN0L0NvbmYtZmlsZXMvVW5wYWNrZWQvaGFsRi1jb25mL0hh
bGYtaW5zdC90cmlnLWFXYWl0L1RyaWctcGVuZA0KfC8gRXJyPz0obm9uZSkvUmVpbnN0LXJlcXVp
cmVkIChTdGF0dXMsRXJyOiB1cHBlcmNhc2U9YmFkKQ0KfHwvIE5hbWXCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVmVyc2lv
bsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFyY2hpdGVjdHVyZcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgRGVzY3JpcHRpb24NCisrKy09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09LT09PT09PT09PT09PT09PT09PT09PT09LT09PT09PT09PT09PT09PT09PT09PT09
LT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09DQppacKgIGJjYWNoZS10b29sc8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuMC44LTLCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBhbWQ2NMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBiY2FjaGUgdXNlcnNwYWNlIHRvb2xzDQoNCj4NCj4+IC0gU3RvcCB3cml0aW5nIGFuZCB3
YWl0IGZvciBkaXJ0eSBkYXRhIHdyaXRlbiBiYWNrDQo+Pg0KPj4gJCBsc2Jsaw0KPj4gTkFNRcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTUFKOk1JTiBSTcKgwqAgU0laRSBSTyBUWVBFIE1PVU5U
UE9JTlQNCj4+IHNkZsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgODo4MMKgwqAgMMKg
wqAgNy4zVMKgIDAgZGlzaw0KPj4g4pSU4pSAYmNhY2hlMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyNTI6MMKg
wqDCoCAwwqDCoCA3LjNUwqAgMCBkaXNrDQo+PiDCoCDilJTilIBjZXBoLS0zMmE0ODFmOS0tMzEz
Yy0tNDE3ZS0tYWFmNy0tYmRkNzQ1MTVmZDg2LW9zZC0tZGF0YS0tMmY2NzA5MjktLTNjOGEtLTQ1
ZGQtLWJjZWYtLWM2MGNlM2VlMDhlMSAyNTM6McKgwqDCoCAwwqDCoCA3LjNUwqAgMCBsdm3CoA0K
Pj4gc2RkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA4OjQ4wqDCoCAwwqDCoCA3LjNU
wqAgMCBkaXNrDQo+PiBzZGLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDg6MTbCoMKg
IDDCoMKgIDcuM1TCoCAwIGRpc2sNCj4+IHNka8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgODoxNjDCoCAwIDg5My44R8KgIDAgZGlzaw0KPj4g4pSU4pSAYmNhY2hlMMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAyNTI6MMKgwqDCoCAwwqDCoCA3LjNUwqAgMCBkaXNrDQo+PiDCoCDilJTilIBjZXBoLS0z
MmE0ODFmOS0tMzEzYy0tNDE3ZS0tYWFmNy0tYmRkNzQ1MTVmZDg2LW9zZC0tZGF0YS0tMmY2NzA5
MjktLTNjOGEtLTQ1ZGQtLWJjZWYtLWM2MGNlM2VlMDhlMSAyNTM6McKgwqDCoCAwwqDCoCA3LjNU
wqAgMCBsdm3CoA0KPj4gJCBjYXQgL3N5cy9ibG9jay9iY2FjaGUwL2JjYWNoZS9kaXJ0eV9kYXRh
DQo+PiAwLjBrDQo+Pg0KPj4gcm9vdEBXWFMwMTA2On4jIGJjYWNoZS1zdXBlci1zaG93IC9kZXYv
c2RmDQo+PiBzYi5tYWdpY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvaw0KPj4gc2Iu
Zmlyc3Rfc2VjdG9ywqDCoMKgwqDCoMKgwqDCoCA4IFttYXRjaF0NCj4+IHNiLmNzdW3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA3MURBOUNBOTY4QjRBNjI1IFttYXRjaF0NCj4+IHNi
LnZlcnNpb27CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxIFtiYWNraW5nIGRldmljZV0NCj4+
DQo+PiBkZXYubGFiZWzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChlbXB0eSkNCj4+IGRl
di51dWlkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGQwN2RjNDM1LTEyOWQtNDc3ZC04
Mzc4LWE2YWY3NTE5OTg1Mg0KPj4gZGV2LnNlY3RvcnNfcGVyX2Jsb2NrwqDCoCA4DQo+PiBkZXYu
c2VjdG9yc19wZXJfYnVja2V0wqAgMTAyNA0KPj4gZGV2LmRhdGEuZmlyc3Rfc2VjdG9ywqDCoCAx
Ng0KPj4gZGV2LmRhdGEuY2FjaGVfbW9kZcKgwqDCoMKgIDEgW3dyaXRlYmFja10NCj4+IGRldi5k
YXRhLmNhY2hlX3N0YXRlwqDCoMKgIDEgW2NsZWFuXQ0KPj4gY3NldC51dWlkwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBkODc3MTNjNi0yZTc2LTRhMDktODUxNy1kNDgzMDY0Njg2NTkNCj4+
DQo+PiAtIGNoZWNrIHRoZSBhdmFpbGFibGUgY2FjaGUNCj4+DQo+PiAjIGNhdCAvc3lzL2ZzL2Jj
YWNoZS9kODc3MTNjNi0yZTc2LTRhMDktODUxNy1kNDgzMDY0Njg2NTkvY2FjaGVfYXZhaWxhYmxl
X3BlcmNlbnQNCj4+IDI3DQo+Pg0KPiBXaGF0IGlzIHRoZSBjb250ZW50IGZyb20NCj4gL3N5cy9m
cy9iY2FjaGUvPGNhY2hlLXNldC11dWlkPi9jYWNoZTAvcHJpb3JpdHlfc3RhdHMgPyBDYW4geW91
IHBhc3QNCj4gaGVyZSB0b28uDQpJIGZvcmdvdCBnZXQgdGhlIGluZm8gYmVmb3JlIEkgdHJpZ2dl
cmVkIGdjLi4uLCBJIHRoaW5rIEkgY2FuIHJlcHJvZHVjZSB0aGUgcHJvYmxlbS4gV2hlbiBJIHJl
cHJvZHVjZSBpdCwgSSB3aWxsIGNvbGxlY3QgdGhlIGluZm9tYXRpb24uDQo+DQo+IFRoZXJlIGlz
IG5vIGRpcnR5IGJsb2NrcywgYnV0IGNhY2hlIGlzIG9jY3VwaWVkIDc4JSBidWNrZXRzLCBpZiB5
b3UgYXJlDQo+IHVzaW5nIDUuOCsga2VybmVsLCB0aGVuIGEgZ2MgaXMgcHJvYmFibHkgZGVzaXJl
ZC4NCj4NCj4gWW91IG1heSB0cnkgdG8gdHJpZ2dlciBhIGdjIGJ5IHdyaXRpbmcgdG8NCj4gc3lz
L2ZzL2JjYWNoZS88Y2FjaGUtc2V0LXV1aWQ+L2ludGVybmFsL3RyaWdnZXJfZ2MNCj4NCldoZW4g
YWxsIGNhY2hlIGhhZCB3cml0dGVuIGJhY2ssIEkgdHJpZ2dlcmVkIGdjLCBpdCByZWNhbGxlZC4N
Cg0Kcm9vdEBXWFMwMTA2On4jIGNhdCAvc3lzL2Jsb2NrL2JjYWNoZTAvYmNhY2hlL2NhY2hlL2Nh
Y2hlX2F2YWlsYWJsZV9wZXJjZW50DQozMA0KDQpyb290QFdYUzAxMDY6fiMgZWNobyAxID4gL3N5
cy9ibG9jay9iY2FjaGUwL2JjYWNoZS9jYWNoZS9pbnRlcm5hbC90cmlnZ2VyX2djDQpyb290QFdY
UzAxMDY6fiMgY2F0IC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUvY2FjaGUvY2FjaGVfYXZhaWxh
YmxlX3BlcmNlbnQNCjk3DQoNCldoeSBtdXN0IEkgdHJpZ2dlciBnYyBtYW51YWxseT8gSXMgbm90
IGEgZGVmYXVsdCBhY3Rpb24gb2YgYmNhY2hlLWdjIHRocmVhZD8gQW5kIEkgZm91bmQgaXQgY2Fu
IG9ubHkgd29yayB3aGVuIGFsbCBkaXJ0eSBkYXRhIHdyaXR0ZW4gYmFjay4NCg0KPj4gQXMgdGhl
IGRvYyBkZXNjcmliZWQ6DQo+Pg0KPj4gY2FjaGVfYXZhaWxhYmxlX3BlcmNlbnQNCj4+ICAgICBQ
ZXJjZW50YWdlIG9mIGNhY2hlIGRldmljZSB3aGljaCBkb2VzbuKAmXQgY29udGFpbiBkaXJ0eSBk
YXRhLCBhbmQgY291bGQgcG90ZW50aWFsbHkgYmUgdXNlZCBmb3Igd3JpdGViYWNrLiBUaGlzIGRv
ZXNu4oCZdCBtZWFuIHRoaXMgc3BhY2UgaXNu4oCZdCB1c2VkIGZvciBjbGVhbiBjYWNoZWQgZGF0
YTsgdGhlIHVudXNlZCBzdGF0aXN0aWMgKGluIHByaW9yaXR5X3N0YXRzKSBpcyB0eXBpY2FsbHkg
bXVjaCBsb3dlci4NCj4+IFdoZW4gYWxsIGRpcnR5IGRhdGEgd3JpdGVuIGJhY2sswqAgd2h5IGNh
Y2hlX2F2YWlsYWJsZV9wZXJjZW50IHdhcyBub3QgMTAwPw0KPj4NCj4+IEFuZCB3aGVuIEkgc3Rh
cnQgdGhlIHdyaXRlIEkvTywgdGhlIG5ldyB3cml0ZW4gZGlkbid0IHJlcGxhY2UgdGhlIGNsZWFu
IGNhY2hlKGl0IHRoaW5rIHRoZSBjYWNoZSBpcyBkaXJ5IG5vdz8pLCBzbyBpdCBjYXVzZSB0aGUg
aGRkIHdpdGggbGFyZ2UgbGF0ZW5jeToNCj4+DQo+PiAuL2Jpbi9pb3Nub29wIC1RIC1kICc4LDgw
Jw0KPj4NCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMzjCoCBXU8KgwqAgOCw4MMKgwqDCoMKg
IDM1MTM3MDE0NzLCoMKgIDQwOTbCoMKgwqDCoCAyMTcuNjkNCj4+IDwuLi4+wqDCoMKgwqDCoMKg
wqAgNzMzMzjCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1MTM3NTkzNjDCoMKgIDQwOTbCoMKgwqDC
oCA0NDguODANCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMzjCoCBXU8KgwqAgOCw4MMKgwqDC
oMKgIDM1NjIyMTE5MTLCoMKgIDQwOTbCoMKgwqDCoCA1MTEuNjkNCj4+IDwuLi4+wqDCoMKgwqDC
oMKgwqAgNzMzMzXCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTI1MjjCoMKgIDQwOTbCoMKg
wqDCoCA1MDUuMDgNCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMznCoCBXU8KgwqAgOCw4MMKg
wqDCoMKgIDM1NjIyMTMzNzbCoMKgIDQwOTbCoMKgwqDCoCA1MDEuMTkNCj4+IDwuLi4+wqDCoMKg
wqDCoMKgwqAgNzMzMzbCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTM5OTLCoMKgIDQwOTbC
oMKgwqDCoCA1MTEuMTYNCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzNDPCoCBXU8KgwqAgOCw4
MMKgwqDCoMKgIDM1NjIyMTQwMTbCoMKgIDQwOTbCoMKgwqDCoCA1MTEuNzQNCj4+IDwuLi4+wqDC
oMKgwqDCoMKgwqAgNzMzNDDCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQxMjjCoMKgIDQw
OTbCoMKgwqDCoCA1MTIuOTUNCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMjnCoCBXU8KgwqAg
OCw4MMKgwqDCoMKgIDM1NjIyMTQyMDjCoMKgIDQwOTbCoMKgwqDCoCA1MTAuNDgNCj4+IDwuLi4+
wqDCoMKgwqDCoMKgwqAgNzMzMzjCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ2MDDCoMKg
IDQwOTbCoMKgwqDCoCA1MTguNjQNCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzNDHCoCBXU8Kg
wqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ2MzLCoMKgIDQwOTbCoMKgwqDCoCA1MTkuMDkNCj4+IDwu
Li4+wqDCoMKgwqDCoMKgwqAgNzMzNDLCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ2NjTC
oMKgIDQwOTbCoMKgwqDCoCA1MTguMjgNCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMzbCoCBX
U8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ2ODjCoMKgIDQwOTbCoMKgwqDCoCA1MTkuMjcNCj4+
IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzNDPCoCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ3
MzbCoMKgIDQwOTbCoMKgwqDCoCA1MjguMzENCj4+IDwuLi4+wqDCoMKgwqDCoMKgwqAgNzMzMznC
oCBXU8KgwqAgOCw4MMKgwqDCoMKgIDM1NjIyMTQ3ODTCoMKgIDQwOTbCoMKgwqDCoCA1MzAuMTMN
Cj4+DQo+IEkganVzdCB3b25kZXJpbmcgd2h5IGdjIHRocmVhZCBkb2VzIG5vdCBydW4gdXAgLi4u
Lg0KPg0KPg0KPiBUaGFua3MuDQo+DQo+IENvbHkgTGkNCj4NCg==
