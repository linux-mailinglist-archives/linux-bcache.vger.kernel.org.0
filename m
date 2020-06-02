Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC8D1EB7B7
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jun 2020 10:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFBIzG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jun 2020 04:55:06 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25184 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgFBIzF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jun 2020 04:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591088104; x=1622624104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4VajPl7LBGBm8jjD0Iprv3ZXoX3BzejzLvcYkyBikNA=;
  b=LmjrLQs8O5YRBowgx9O9DTUsy9nmuhspEhuDKDmnrpa5D9HRP8dO2xFh
   ufA1X0cGKrm3t+o5CGryvdbLLWqoD3OqeGapZUmHJ8uEOj0QR3ml0pV4P
   qWFKbA4FY3eDjAIK2Hq46OlGPeomsS2turUbI5/EC6N3RhmxjqbVREyMJ
   kNm/zjm2gl7ljEzxUGd3juExPXZmvRyK8oEE4P5fD9/+QjGiZl7h8wPeG
   2SLso22AqsxOCUm4f1NLLGQIRit1IFmz9hvIFaWKkApNxGmbqe0t2/2tt
   /tyDNsEvPl81/vDSI8+yI2esdu/NTkDx0nUjL8CjuzjX6b01ymD2qRsck
   g==;
IronPort-SDR: 7XIm3u0qKssH6PKfUCbd+2F6kEmyrvPUvU5Og+t3k7oMWtKl0EpT5xzvEO634TruECAYGS0hjP
 Ewji2v5FEoHYkc8i2JP21Z7FBVcpn/ck2WeHlrZMfORbRqnrso9AX9puqScyEzze5tacOKAp6i
 1SREaqcAWt7k3vZAzl+vSzdRcHWB+3fgSL5y+VNbveaOTfYBsvG+Zvk3wt96WjaNiXH94R04tS
 RAu8ztR9VKI8DVrwIIn/j0BXDbaKGzhPrVX9QbY9k4HfeLuWyaCkksjyAXq/mKRY+hmNA/fQUt
 Jrs=
X-IronPort-AV: E=Sophos;i="5.73,463,1583164800"; 
   d="scan'208";a="139009721"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2020 16:55:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Al3TbZ6v7umRWtvzOMMYhjcLjxp4TEjYIx2xiDs6CL7mMdSH7WP2bbpyacEK593qG/Eh7m3ZmsxhNvqIZDoWJYprDJNSZFtfl+Cxqh1UihbGZ4wf4ub0gwhh4RErsCIYXdtmawVBVQ70PwMJjrVMimpw00ulxsLzbFFx9g+cLWz8obrgIa0Bsul/ZB5Q89Ih//1ZeIZ8AUU7txbo52XJ6ctRIvM05UHnQWH1oa0dVsWSHSxb7wURjjhEPaDI/ptt7P72d+PDhd6d94Njsg3yqLf/TdW+SFegkz5Z/2AsgjtDkIKTDygVUoRbHZquRuYAx376zZk0rxeNn65SkB9J7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VajPl7LBGBm8jjD0Iprv3ZXoX3BzejzLvcYkyBikNA=;
 b=fCnj/OjG0XmSXw+PRUBpYFoZ7w75d88S07Nh7Ga1a7fNU24wH/7V5SRJNJgdyTF/3knNnEzgVDJmMkvXGAq0eSlK2nEZEboCNfNpEPuCYGr517U9ueuN635i2dYZrcdnKa/bZMjxC+77oxF/xxEAzWgf+5x1f8iMFOGG+V62K98s3COpnqpqAuQWrth9r7okwavxWh7k/BlJa7gSDbR4coErfKcubs4kWOcybqN6GPZsmwTSW7clQpjNveEWoeZ5PtCyhT9+kjgP/SE2M7aHXCI1EWb5OLD/gJOSDoycabqnG5xNJKD5f6qKkbXyn4diERb99AgatW4q7C7AdfXlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VajPl7LBGBm8jjD0Iprv3ZXoX3BzejzLvcYkyBikNA=;
 b=URIKPc5QZdLFBeM7L6INbXYWCaoRyZD9eCKnAk5Y91q3AezQHCXw8peWNQspFi2ahMKJhnjTuqP69+ixjm1og8E5PAGS/GsniaKWgNRAYmmlKf37pyTj88b7srMOYU6jXY6nZygRvOR457bjYwT7w0DW2DCmEnw4ysrXxU/kpBk=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1065.namprd04.prod.outlook.com (2603:10b6:910:54::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Tue, 2 Jun
 2020 08:55:00 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 08:55:00 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Thread-Topic: [RFC PATCH v4 2/3] bcache: handle zone management bios for
 bcache device
Thread-Index: AQHWMDMrALMD8aFhJEWGpHp2plS4g6jD/LyAgAEZ2QA=
Date:   Tue, 2 Jun 2020 08:54:59 +0000
Message-ID: <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
References: <20200522121837.109651-1-colyli@suse.de>
         <20200522121837.109651-3-colyli@suse.de>
         <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
         <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
In-Reply-To: <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:62d1:16e6:ecb1:d604]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c707569c-3ad4-496a-1395-08d806d2a1d2
x-ms-traffictypediagnostic: CY4PR04MB1065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1065F17E561DF49C51690F68E78B0@CY4PR04MB1065.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 84d4YNUawJ1viuCX64HxDbhHUYPKtRy31y4eQky+WNIe2NnogXev4h2uju93k6IQpPzr9yFaQUB6lbyTG6EU5/iwGbJjAQQBEUvYoArI2T/4BAwgKs6BpRPgl8zRV41Rcgu08uRuQAXSDGh3JVfneB45Ujuf3KL2ZLuQowVDnjnA050skwI2AEYENCiD9fRvIgfUxmWnuDRMGRvUcW3LzQGc2LtodbMIW0q54TPGIV8jVuAPxv9DoYDiAB7rMRkkdkhdZ6lcIa5gGYgSBSJONYTYOZo4Vtl6Uw1m3GBs0BS8cv7E1zvFsCjbWV8WyK8IvrwCzpETvtLUrmWaPJJaSkb4qSrjQKCOite9Ai0cZNSvnfysdtd/tGJ5x2YN+cUT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(186003)(86362001)(71200400001)(478600001)(36756003)(2906002)(110136005)(316002)(6506007)(54906003)(5660300002)(66446008)(8676002)(8936002)(83380400001)(6512007)(2616005)(64756008)(66946007)(4326008)(91956017)(76116006)(6486002)(66556008)(66476007)(6314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZYoihz0wzxlBt20gjL5woCA90RtUqz6z8CHlXVCNQ7Ta1qgt4/vfJuzOS30YT3hAmoKd9fMZb5apDD6UQkYpEH9MtyT1WKZdmFb0Ts3nMK/Y23eYVFRbLPlsvy7Yb3hTtGyfag6uvBaupHravZSWFuKqhwsaiMdN0OmkKqAiR7VVROM/KnGussRnGZDXI2fW+nD7TAkOsdapip2G8MJN96+5hz6JkOHMisnPoAtoPZe05jFJEfdVymVqWIqqd0/kDxxCmFeWV64ZFBEX5K+Ieb0oodhGYnbONEyf9koqXCJbsdeA4iheEGL3e0VF7QEtlO5ZKPXLYjkbD4e+XYTOvmWoylWvzVzKbux24NxU2+yRiCNi3YKJ3AgSbgtwRkAM4mqP0xFWKJatnzuIFYlnhR078p+JsBkHGl/fcSnVMkA2k2qgMGm4UOyW9ZK14WRQhx5CwPh8CelXqi1xmMvlSXcmByLAnnCkCJ3ICfN1Lu+ralzf5wcUoGw53uQnoVbfUeDUdIgGv1Wt4DLJir0bc3L87Gvq9QlOCzDtFjr0q8k/b1FnLEZPNRX7k07JutYB
Content-Type: text/plain; charset="utf-8"
Content-ID: <566ADE088CAA274F9D3B112FB6501C07@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c707569c-3ad4-496a-1395-08d806d2a1d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 08:54:59.9863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+/mtwsnOkb9/+GWBPmTMTR8THVrcPt6Z4JRDbLMfLVapADj5CYTpIWOGrOi6JaflL6/C77rFUffzzDiTa9ATw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1065
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTAyIGF0IDAwOjA2ICswODAwLCBDb2x5IExpIHdyb3RlOg0KPiA+ID4g
KwkJICogY2FjaGUgZGV2aWNlLg0KPiA+ID4gKwkJICovDQo+ID4gPiArCQlpZiAoYmlvX29wKGJp
bykgPT0gUkVRX09QX1pPTkVfUkVTRVRfQUxMKQ0KPiA+ID4gKwkJCW5yX3pvbmVzID0gcy0+ZC0+
ZGlzay0+cXVldWUtPm5yX3pvbmVzOw0KPiA+IA0KPiA+IE5vdDogc2VuZGluZyBhIFJFUV9PUF9a
T05FX1JFU0VUIEJJTyB0byBhIGNvbnZlbnRpb25hbCB6b25lIHdpbGwgYmUgZmFpbGVkIGJ5DQo+
ID4gdGhlIGRpc2suLi4gVGhpcyBpcyBub3QgYWxsb3dlZCBieSB0aGUgWkJDL1pBQyBzcGVjcy4g
U28gaW52YWxpZGF0aW9uIHRoZSBjYWNoZQ0KPiA+IGZvciBjb252ZW50aW9uYWwgem9uZXMgaXMg
bm90IHJlYWxseSBuZWNlc3NhcnkuIEJ1dCBhcyBhbiBpbml0aWFsIHN1cHBvcnQsIEkNCj4gPiB0
aGluayB0aGlzIGlzIGZpbmUuIFRoaXMgY2FuIGJlIG9wdGltaXplZCBsYXRlci4NCj4gPiANCj4g
Q29waWVkLCB3aWxsIHRoaW5rIG9mIGhvdyB0byBvcHRpbWl6ZWQgbGF0ZXIuIFNvIGZhciBpbiBt
eSB0ZXN0aW5nLA0KPiByZXNldHRpbmcgY29udmVudGlvbmFsIHpvbmVzIG1heSByZWNlaXZlIGVy
cm9yIGFuZCB0aW1lb3V0IGZyb20NCj4gdW5kZXJseWluZyBkcml2ZXJzIGFuZCBiY2FjaGUgY29k
ZSBqdXN0IGZvcndhcmRzIHN1Y2ggZXJyb3IgdG8gdXBwZXINCj4gbGF5ZXIuIFdoYXQgSSBzZWUg
aXMgdGhlIHJlc2V0IGNvbW1hbmQgaGFuZ3MgZm9yIGEgcXVpdGUgbG9uZyB0aW1lIGFuZA0KPiBm
YWlsZWQuIEkgd2lsbCBmaW5kIGEgd2F5IHRvIG1ha2UgdGhlIHpvbmUgcmVzZXQgY29tbWFuZCBv
biBjb252ZW50aW9uYWwNCj4gem9uZSBmYWlsIGltbWVkaWF0ZWx5Lg0KDQpJdCBpcyAxMDAlIGd1
YXJhbnRlZWQgdGhhdCBhIHpvbmUgcmVzZXQgaXNzdWVkIHRvIGEgY29udmVudGlvbmFsIHpvbmUN
CndpbGwgZmFpbC4gVGhhdCBpcyBkZWZpbmVkIGluIFpCQy9aQUMgc3BlY2lmaWNhdGlvbnMuIFJl
c2V0dGluZyBhDQpzaW5nbGUgY29udmVudGlvbmFsIHpvbmUgaXMgYW4gZXJyb3IuIFdlIGtub3cg
dGhlIGNvbW1hbmQgd2lsbCBmYWlsIGFuZA0KdGhlIGZhaWx1cmUgaXMgaW5zdGFudGFuZW91cyBm
cm9tIHRoZSBkcml2ZS4gVGhlIHNjc2kgbGF5ZXIgc2hvdWxkIG5vdA0KcmV0cnkgdGhlc2UgZmFp
bGVkIHJlc2V0IHpvbmUgY29tbWFuZCwgd2UgaGF2ZSBzcGVjaWFsIGVycm9yIGhhbmRsaW5nDQpj
b2RlIHByZXZlbnRpbmcgcmV0cmllcyBzaW5jZSB3ZSBrbm93IHRoYXQgdGhlIGNvbW1hbmQgY2Fu
IG9ubHkgZmFpbA0KYWdhaW4uIFNvIEkgYW0gbm90IHN1cmUgd2h5IHlvdSBhcmUgc2VlaW5nIGhh
bmcvbG9uZyB0aW1lIGJlZm9yZSB0aGUNCmZhaWx1cmUgaXMgc2lnbmFsZWQuLi4gVGhpcyBtYXkg
bmVlZCBpbnZlc3RpZ2F0aW9uLg0KDQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGln
aXRhbCBSZXNlYXJjaA0K
