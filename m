Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F331465C
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Feb 2021 03:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhBICbI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 21:31:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:57788 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhBICbE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 21:31:04 -0500
IronPort-SDR: myHA5paTHyp3YBxIZzG418ZCK+GIZsldGJ3JZgTye7wQUx36K1YTGYOMkJkLYVg4jvfvbhZsrO
 Bje9D0CxVMHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="160969887"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="160969887"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 18:30:22 -0800
IronPort-SDR: Q4/+cwOvtrizN0AtWHnZy4QW5EqN5s2pZJ4TQaz/iMGRXdpsQaWaPBLWCJFoaPrkW3/2BEtEAZ
 qQIYJ0pBN7TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="411686742"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 08 Feb 2021 18:30:22 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 8 Feb 2021 18:30:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 8 Feb 2021 18:30:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 8 Feb 2021 18:30:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 8 Feb 2021 18:30:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDYGLEzH4tyrCwt/YUTH9WwvmL5vMwC8yLTNypazhrGwk0RMtnU3arpq5ipYq0v6SvBfnl7MhGPbdahITd+RIYi3gscQIYS2x7lOg9NNnAS2PzWFQDaxWjILzKXWnOY9YSDUKKcKKjedqk4mNV8h+bsUA+381bT+a6awvoOHppE0zgnES379G82r1nPzY0TLpGqMN4hIHiA0aRhrHd2NNiB98RxWjKirsik7fd73bqub5TWJVlwWTGdnX9Pg4o5AGBu2DakTFb98EmCNxdQiw2dVAcR953ATz7SV1h44koe575rJ3T7WEChzASwlWnCfThkbw94tRauaqteyzciSmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rhm4PxWf1dBwK6sHdshsdcgRgU2fjHQ4ueML175/2M=;
 b=f77vsc0FpBP+FUDEz9yG7UwxhhBthKybqHpJv9FC8EieM7HdvqyI4ihNgqztWylhp5GtPgYrnbtURFXAB1ptpqI9VrNyNvmEaWXj7xIM4mf7s6ZlTi4mTYEMgsFIhxnrqjxXmtchZfrvdJYudFAx+H1JLgkjXjrnWJz9mTdRaOvJ4dUtA2TA0GeGNhOEpE+YNjmb9WeSBm4Ts5lLLt8MAYraKVQ8SUuhY6lQULsDBdNvQvaSEXxPcj04SkHTm4nZ61WcSSDuIlkjwnmJLRK7uCdHCRzFCDYmMM+O0SBb5WOeurI718Ri2zv5jZ5W4EFQZUZ0o1W/z6Qnnbjwyiw0Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rhm4PxWf1dBwK6sHdshsdcgRgU2fjHQ4ueML175/2M=;
 b=AAllA7UtMRj4G1Ibp+NCMD+/+a+KTWuM4j9smyAoxXYS9pAfx4267IYku5YK3ng8hjLVVG3MibPIerIeuTvWP9LYbRcMVgJgci1L3ppbh8PxLXnjymYjCvbQW9Z0ubA0PryFRsz4Va+K7v6ogbsuALCNnQZD0AbcUJhCUK2D1EY=
Received: from BYAPR11MB2696.namprd11.prod.outlook.com (2603:10b6:a02:c5::29)
 by BYAPR11MB2744.namprd11.prod.outlook.com (2603:10b6:a02:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Tue, 9 Feb
 2021 02:30:19 +0000
Received: from BYAPR11MB2696.namprd11.prod.outlook.com
 ([fe80::f9e4:dba6:9571:928c]) by BYAPR11MB2696.namprd11.prod.outlook.com
 ([fe80::f9e4:dba6:9571:928c%4]) with mapi id 15.20.3825.027; Tue, 9 Feb 2021
 02:30:19 +0000
From:   "Ren, Qiaowei" <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>, "Ma, Jianpeng" <jianpeng.ma@intel.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: RE: [RFC PATCH v6 0/7] nvm page allocator for bcache
Thread-Topic: [RFC PATCH v6 0/7] nvm page allocator for bcache
Thread-Index: AQHW/iFUmhGt6/Kn6k+D0rNdlWxWVapPGdwA
Date:   Tue, 9 Feb 2021 02:30:19 +0000
Message-ID: <BYAPR11MB26962B941509DA38036F852EF58E9@BYAPR11MB2696.namprd11.prod.outlook.com>
References: <20210208142621.76815-1-qiaowei.ren@intel.com>
 <0c4ba429-9697-be06-e5a4-4bd3a07c6275@suse.de>
In-Reply-To: <0c4ba429-9697-be06-e5a4-4bd3a07c6275@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3438d94c-9257-4ab8-cd16-08d8cca2a4b3
x-ms-traffictypediagnostic: BYAPR11MB2744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB274464BE932710C3D4A52EE5F58E9@BYAPR11MB2744.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E4OktFbNORssTX+v/+8XI7X9wMrZ3r470CpQpA98JeRlC0tylIRxelnXHZynYrCs0Eg95nWpocTPwz7O1JWrapMlsgfcAr2CjKxF45MaHwS6PZIAvFy26vDQLvjEIIgt3YybfcekkQkE+tfk+BrdpabrS1OxmUL4v0hYoexniZEgU3XS9kCRwZT5Ikrm5Ue/U0PGRa2ScIk737Ttkcey5tlCwNg0AghKky43CbZjztcA5DD70xTNX2Vtl53gIdG5zBgJpNG5vDV1/e5f7vVq5WcG8SU1tjg6JF+YNm5mLzURDpiT3hAbrmUDDI5qb+6qZxgIz0MQ4BkA3bpRZakTAc/gl4o9JsL1lYgrQKh0YDosMrXj0GKUvBiFUw3xXnUZumeSIOuG+eXsv49PcvuhjQsYmd/jrxTbWlMR5aW1B09D/8JVO1hCNF5scHJ4BE151snHWR870Pv5kIxXqX9760g65igZXfi+Nn+4qDHSt2l4nxfxIT2zavtC5mSN6KiBU9PW58awILvkdnD24dXA+5H2UezC7AR0PMOGj7Dg/zxIKNeKZrPMMv4BB5Qtvbb45sHGp/7yG1BaPBiSkZe89s5rl2Z8ymmeukr7kUBc/wE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2696.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(478600001)(966005)(7696005)(5660300002)(4326008)(52536014)(8936002)(55016002)(9686003)(6636002)(6506007)(8676002)(66946007)(2906002)(110136005)(76116006)(66556008)(64756008)(66476007)(316002)(186003)(86362001)(33656002)(83380400001)(53546011)(26005)(71200400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZDhPUVBBWkVpalpHaC90YkhQZk4xSGlubllDZkJEMW1wVG05azM0MXJjQU9K?=
 =?utf-8?B?anJDNDh1YmR6UEZINFl3aVBtWFRJbVdNcU4xUW5aOUM5OUtYdXdrTkE2ZlBo?=
 =?utf-8?B?VW1kT0FPVkpBeUhRcjcwZ2pJQWRtR0EwWWxWc1hUc0lYT2N6K1VVR0FLTnlE?=
 =?utf-8?B?NVB1SWMzTWxWOHkrc3lCNVlFN2xmMDArOHc2YkVyTVkvc2ExZ2xtZ0FadlBa?=
 =?utf-8?B?TEU5N1BXN0NHL0tpejFaU1UxMmpIeEQ2bW00cEFMSC83WEVWTWhtbDlYTFRL?=
 =?utf-8?B?bnJpWFpkRGh4cXBlNUQxL2p5cklBd0RYQ252amlrZEIrQjhqdHBQTVlTUkVt?=
 =?utf-8?B?cVdwWHV3ZWpMTDQ4N3NqUVF0U1g1NzloY2FTbFNHOUJTdkhHUEVpbWxZcVBY?=
 =?utf-8?B?eWdyaU5oL0NiTDRTMG9uaEJ3bzFMaFFDQzQvM3JXZ0tiaVp6SklUYkQxeGRJ?=
 =?utf-8?B?WWpHZGxURVl4MFVCdTA5TlNtR3hDMlV1a04vSHpYR1kxS3RNR09PR0lqYW1J?=
 =?utf-8?B?WTBlUUw0K3N6RXIrZEVSdjdBMFpqdWN6SnIzRVdiVnRDRWMxYjVXSG95eno1?=
 =?utf-8?B?VnBBcnZmNGRqMFVsa2NBY0xhbm42b0VCZ1FFZVZ5RjVRd01RSEp6UW9SSXBS?=
 =?utf-8?B?VVBxRVNqZjQ0dFlGZEJiOU9BaWNKb0NCdE42Z3N1TkdhR2xJZnZxdkxGMC9h?=
 =?utf-8?B?bkMzeHJ1dStEUXFuRVFDWC9EbjFiRDc4QVJFanFYL2puSnNIK2IxV0twU0wy?=
 =?utf-8?B?c05SeE9ncWhHNXhmVmRUWlp5M3BmSmZlejRTVzY5cWZHUlRab25rOE5XMG9D?=
 =?utf-8?B?TWJPSFFscVBJeHYwV1NEMlVoMUJ2d2I1aHBrTkVJNzZYUG9wVE1keDBVcGdn?=
 =?utf-8?B?bXlBVzNubjcxcWFVQlZMbURINklzcldPMmxlcFZhbi9tbDhXZzlFa0NDNlJF?=
 =?utf-8?B?WWh4eitzOE1PV25YUzAxUGlZMFdXaUFVcFNOYkk2Z2djOU5jV05YaGNrcW5E?=
 =?utf-8?B?NFYxMTlxRUlNYXFpVnMxN2ZJZFNnWXI4aDd1dndKQlhkZTZUMWloQnUxOWpo?=
 =?utf-8?B?em1HOFVxUkNIUmtRN0VCL0ExdnZKSmJudmFxTkJ2d24xSGpOMXd3WCt6T1B2?=
 =?utf-8?B?NkVIMDN4TzVEU05Ha2l3SkF6ejFleFpvOVJwVW9Qb0Jwc0gxckFVSVJIUm0r?=
 =?utf-8?B?ZnRzcVdwWFZpc2s4SGFyTjUvWUZXWFdDL1NCUVM2L3dqc3lVTWZYZzZvYklC?=
 =?utf-8?B?WGtrU0dneFE5R2pJckZuMk1hdGxvN0NOZmhBZjZvbFc2S1R0MCtzZkZ0bUNL?=
 =?utf-8?B?REx0alFCMFJ4NzlZRUJvZFdPbEpRRytuOHh3NFJaUU1zNUdLMVE4WlROaEU5?=
 =?utf-8?B?OHR2elFLVDlZZTB6dFU1cEtzYUtqVmpVc1N5am1CMng0SUQvRVZNUmhCSGwy?=
 =?utf-8?B?dll3SE83RmFUUFh1b2JnSWZPWTA4dmJEdG1tcDhsWHhsS1JVenc1MjJ6ZWVl?=
 =?utf-8?B?UmdUK0xTVGZ5VmxOTHBHMFR1aEk4bklXVVc3cnJRSE45akdSeFY4OFM3SDVJ?=
 =?utf-8?B?MzRyTUVsejJwbWVYNkliWHFxVndMNlZlbFlsTlpScGw3YVV3OTdnY0VRTXhj?=
 =?utf-8?B?RFdvSG4yTFhaUmlNVVUzWGtsM1dHYVdxQVI1TzI4b3hWWllHOW9OS3A2ak96?=
 =?utf-8?B?L3c4OW40NjlBQkwzY2FlODVsQWFSbnpJdk1KcXR4Vkl3aGdPUTRBcThrUHo3?=
 =?utf-8?Q?PR2jySvijmZ9AnusYK2R6+mTNdKFx4QeHFYFHES?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2696.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3438d94c-9257-4ab8-cd16-08d8cca2a4b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 02:30:19.1900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpgnFGi0jHrhHlJf6At0h8qnJQhilqHn3VHjcCVeT1tlheB4Yq3g6pE0EgQZr+wb3hg6yyskMdcsKc7I6RWj9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2744
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbHkgTGkgPGNvbHlsaUBz
dXNlLmRlPg0KPiBTZW50OiBNb25kYXksIEZlYnJ1YXJ5IDgsIDIwMjEgOTo1MCBQTQ0KPiBUbzog
UmVuLCBRaWFvd2VpIDxxaWFvd2VpLnJlbkBpbnRlbC5jb20+OyBNYSwgSmlhbnBlbmcNCj4gPGpp
YW5wZW5nLm1hQGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjYgMC83XSBudm0gcGFnZSBhbGxvY2F0b3IgZm9y
IGJjYWNoZQ0KPiANCj4gT24gMi84LzIxIDEwOjI2IFBNLCBRaWFvd2VpIFJlbiB3cm90ZToNCj4g
PiBUaGlzIHNlcmllcyBpbXBsZW1lbnRzIG52bSBwYWdlcyBhbGxvY2F0b3IgZm9yIGJjYWNoZS4g
VGhpcyBpZGVhIGlzDQo+ID4gZnJvbSBvbmUgZGlzY3Vzc2lvbiBhYm91dCBudmRpbW0gdXNlIGNh
c2UgaW4ga2VybmVsIHRvZ2V0aGVyIHdpdGgNCj4gPiBDb2x5LiBDb2x5IHNlbnQgdGhlIGZvbGxv
d2luZyBlbWFpbCBhYm91dCB0aGlzIGlkZWEgdG8gZ2l2ZSBzb21lDQo+ID4gaW50cm9kdWN0aW9u
IG9uIHdoYXQgd2Ugd2lsbCBkbyBiZWZvcmU6DQo+ID4NCj4gPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1iY2FjaGUvYmM3ZTcxZWMtOTdlYi1iMjI2LWQ0ZmMtZDhiNjRjMWVmDQo+ID4g
NDFhQHN1c2UuZGUvDQo+ID4NCj4gPiBIZXJlIHRoaXMgc2VyaWVzIGZvY3VzIG9uIHRoZSBmaXJz
dCBzdGVwIGluIGFib3ZlIGVtYWlsLCB0aGF0IGlzIHRvDQo+ID4gc2F5LCB0aGlzIHBhdGNoIHNl
dCBpbXBsZW1lbnRzIGEgZ2VuZXJpYyBmcmFtZXdvcmsgaW4gYmNhY2hlIHRvDQo+ID4gYWxsb2Nh
dGUvcmVsZWFzZSBOVi1tZW1vcnkgcGFnZXMsIGFuZCBwcm92aWRlIGFsbG9jYXRlZCBwYWdlcyBm
b3IgZWFjaA0KPiByZXF1ZXN0b3IgYWZ0ZXIgcmVib290Lg0KPiA+IEluIG9yZGVyIHRvIGRvIHRo
aXMsIG9uZSBzaW1wbGUgYnVkZHkgc3lzdGVtIGlzIGltcGxlbWVudGVkIHRvIG1hbmFnZQ0KPiA+
IE5WLW1lbW9yeSBwYWdlcy4NCj4gPg0KPiA+IFRoaXMgc2V0IGluY2x1ZGVzIG9uZSB0ZXN0aW5n
IG1vZHVsZSB3aGljaCBjYW4gYmUgdXNlZCBmb3Igc2ltcGxlIHRlc3QNCj4gY2FzZXMuDQo+ID4g
TmV4dCBuZWVkIHRvIHN0cm9lIGJjYWNoZSBsb2cgb3IgaW50ZXJuYWwgYnRyZWUgbm9kZXMgaW50
byBudmRpbW0NCj4gPiBiYXNlZCBvbiB0aGVzZSBidWRkeSBhcGlzIHRvIGRvIG1vcmUgdGVzdGlu
Zy4NCj4gPg0KPiA+IFFpYW93ZWkgUmVuICg3KToNCj4gPiAgIGJjYWNoZTogYWRkIGluaXRpYWwg
ZGF0YSBzdHJ1Y3R1cmVzIGZvciBudm0gcGFnZXMNCj4gPiAgIGJjYWNoZTogaW5pdGlhbGl6ZSB0
aGUgbnZtIHBhZ2VzIGFsbG9jYXRvcg0KPiA+ICAgYmNhY2hlOiBpbml0aWFsaXphdGlvbiBvZiB0
aGUgYnVkZHkNCj4gPiAgIGJjYWNoZTogYmNoX252bV9hbGxvY19wYWdlcygpIG9mIHRoZSBidWRk
eQ0KPiA+ICAgYmNhY2hlOiBiY2hfbnZtX2ZyZWVfcGFnZXMoKSBvZiB0aGUgYnVkZHkNCj4gPiAg
IGJjYWNoZTogZ2V0IGFsbG9jYXRlZCBwYWdlcyBmcm9tIHNwZWNpZmljIG93bmVyDQo+ID4gICBi
Y2FjaGU6IHBlcnNpc3Qgb3duZXIgaW5mbyB3aGVuIGFsbG9jL2ZyZWUgcGFnZXMuDQo+IA0KPiBJ
IHRlc3QgdGhlIFY2IHBhdGNoIHNldCwgaXQgd29ya3Mgd2l0aCBjdXJyZW50IGJjYWNoZSBwYXJ0
IGNoYW5nZS4gU29ycnkgZm9yDQo+IG5vdCByZXNwb25zZSBmb3IgdGhlIHByZXZpb3VzIHNlcmll
cyBpbiB0aW1lIG9uIGxpc3QsIGJ1dCB0aGFuayB5b3UgYWxsIHRvIGZpeA0KPiB0aGUga25vd24g
aXNzdWVzIGluIHByZXZpb3VzIHZlcnNpb24uDQo+IA0KPiBBbHRob3VnaCB0aGUgc2VyaWVzIGlz
IHN0aWxsIG1hcmtlZCBhcyBSRkMgcGF0Y2hlcywgYnV0IElNSE8gdGhleSBhcmUgaW4gZ29vZA0K
PiBzaGFwZSBmb3IgYW4gRVhQRVJJTUVOVEFMIHNlcmllcy4NCj4gDQo+IEkgd2lsbCBoYXZlIHRo
ZW0gd2l0aCBteSBvdGhlciBiY2FjaGUgY2hhbmdlcyBpbiB0aGUgdjUuMTIgZm9yLW5leHQsIGFu
ZCBpdCBpcw0KPiBzbyBmYXIgc28gZ29vZCBpbiBteSBzbW9raW5nIHRlc3RpbmcuDQo+IA0KPiBU
aGVyZSBpcyBvbmUgdGhpbmcgSSBmZWVsIHNob3VsZCBiZSBjbGFyaWZpZWQgZnJvbSB5b3UsIEkg
c2VlIHNvbWUgcGF0Y2hlcyB0aGUNCj4gYXV0aG9yIGFuZCB0aGUgZmlyc3Qgc2lnbmVkLW9mZi1i
eSBwZXJzb24gaXMgbm90IGlkZW50aWNhbC4NCj4gUGxlYXNlIG1ha2UgdGhlIGZpcnN0IFNPQiBw
ZW9wbGUgdG8gYmUgdGhlIHNhbWUgb25lIGluIHRoZSBGcm9tL0F1dGhvcg0KPiBmaWVsZC4gQW5k
IEkgZ3Vlc3MgbWF5YmUgbW9zdCBvZiB0aGUgd29yayBhcmUgZG9uZSBieSBib3RoIG9mIHlvdSwg
aWYgdGhpcyBpcw0KPiB0cnVlLCB0aGUgc2Vjb25kIGF1dGhvciBjYW4gdXNlIGEgQ28tYXV0aG9y
ZWQtYnk6IHRhZyBhZnRlciB0aGUgZmlyc3QgU2lnbmVkLQ0KPiBvZmYtYnk6IHBlcnNvbi4NCj4g
DQpZZXMsIGl0IGlzIHRydWUsIGJ1dCB0aGUgRnJvbS9BdXRob3IgZmllbGQgc2hvdWxkIGJlIEpp
YW5wZW5nLiBUaGFua3MuDQoNCj4gVGhlIHY2IHNlcmllcyBpcyB1bmRlciB0ZXN0aW5nIG5vdywg
c28gaXQgaXMgdW5uZWNlc3NhcnkgdG8gcG9zdCBvbmUgbW9yZQ0KPiB2ZXJzaW9uIGZvciB0aGUg
YWJvdmUgY2hhbmdlcy4gSSdkIGxpa2UgdG8gY2hhbmdlIHRoZW0gZnJvbSBteSBzaWRlIGlmIHlv
dQ0KPiBtYXkgcHJvdmlkZSBtZSBzb21lIGhpbnRzLg0KPiANCj4gVGhhbmtzIGZvciB0aGUgY29u
dHJpYnV0aW9uLCB0aGUgdGlueSBOVkRJTU0gcGFnZXMgYWxsY29hdG9yIHdvcmtzLg0KPiANCj4g
Q29seSBMaQ0K
