Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7634DE17
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Mar 2021 04:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhC3CNi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Mar 2021 22:13:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:62730 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhC3CNV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Mar 2021 22:13:21 -0400
IronPort-SDR: GF/n4qACNhkv1uSaK6kvTH7MLX2UMpdQ06N8HBPIoqbspjbI6YjUCWUm2XYcuV/m/8WPZHCIHn
 ZepcR3zcndCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="276834120"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="276834120"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 19:13:21 -0700
IronPort-SDR: KGuB5+jFHloOSopzzIYPNglGrvuKSDjw5EoeQAUDGR9+31urBWJrO8cDwl7yihy8Yx6jZtrEo8
 nTSM4d4SkdYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="417943359"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 19:13:19 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 19:13:18 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 19:13:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 29 Mar 2021 19:13:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 29 Mar 2021 19:13:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MH2xdUsyFB8cDa3FLaBreQrPy1OlJVVxM0CevkDqi+jj1gKQl7fX+HLFRcSCMxPleTsH8WnuQUy3h1QMMQFcVLaF+Wcc8jOGl1V1i2cnN2fJUQdQq11OD5eH4KYqy9a/yWQhCtiyKKwNXab+5FabhtBml4E60j9CmOYlSdnYzL3iXNvPvvoQmsNpGHvLy0JoLNb56hFjndSGLxUWPejMEFIGiC9Or/AFJ0UAs07h7BwspFx/tX+N1nyVwTVD4qxfgu2b2UlG8CrH0XYgC36uaDajC5YecBOvdwzHWtchrtSISvzBeGeKEpyL/3Sz00tOCCbgDW5eolin9eYM0vFqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAAUCDazw8V1wQKOJ1PRz9V5WioNqwgfZY4dV0DLxV8=;
 b=V8F7+Ctu1wwMtQoniaDLlFkg3fmzngcQVcU8A1PewQH8HyryuhBmrZqZPcKwoL4rJn4P29dpxdhMQgw/wE5NP3T7ZWl/LT2zs3iTMkMt1pVe48+md4OdhruvzrsI7exmcYsPVP53TmGfkCxcfP5OiIehSye92BKn71Cw25IsC94wrcpaxPsvOBPoyG78pMGMayHWkjwpu1j/gw044VXNmXnqm4VpghiBkEQDbjIzyKWV9rVbVIA5ME1jDoB5DvmslN1iYg3LDOSii3YUR8cb7PEki29UBWYZ7VSJhgYhHAULpy4/B/MGjKXBnOI7UoRHYaEy8xwoCzKVkIiXYxJEOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAAUCDazw8V1wQKOJ1PRz9V5WioNqwgfZY4dV0DLxV8=;
 b=GvPaXrquwPOktI5nD4ehfZAHW4okri4AhLipbRE9LFyJUK3wDY4Xs42HDnZT0anJOqiqmx8Kd3IOM1hRds5cNVDodmhU7stwvangIBBQApVtGGYZyglJ/uRX2B3UxpQ+7u6rCsKHIheqZWXwSbfkPTyQc/tp1165wOOs1jK0kTU=
Received: from BN7PR11MB2609.namprd11.prod.outlook.com (2603:10b6:406:b1::26)
 by BN6PR11MB1394.namprd11.prod.outlook.com (2603:10b6:404:49::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 02:13:14 +0000
Received: from BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::1a0:2638:6858:a157]) by BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::1a0:2638:6858:a157%7]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 02:13:14 +0000
From:   "Ma, Jianpeng" <jianpeng.ma@intel.com>
To:     Coly Li <colyli@suse.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: RE: [bch-nvm-pages v7 3/6] bcache: initialization of the buddy
Thread-Topic: [bch-nvm-pages v7 3/6] bcache: initialization of the buddy
Thread-Index: AQHXGv95mkLXtCAaYUqSqxTRlvBFaaqa4iQAgAD8IOA=
Date:   Tue, 30 Mar 2021 02:13:14 +0000
Message-ID: <BN7PR11MB2609D64067A97CDAF31FD6D4FD7D9@BN7PR11MB2609.namprd11.prod.outlook.com>
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
 <20210317151029.40735-4-qiaowei.ren@intel.com>
 <e52b3a34-b394-0d16-56b9-edb1e5ba9933@suse.de>
In-Reply-To: <e52b3a34-b394-0d16-56b9-edb1e5ba9933@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fddc7fb2-d7f6-425c-97cf-08d8f3215ff8
x-ms-traffictypediagnostic: BN6PR11MB1394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1394792E1831A9B44CBE5433FD7D9@BN6PR11MB1394.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+9m2XHfo5CgNWEP/BmL6fVGkaSYC0BOtVmOg6lQw6G+zgfUNa60K9D4vDJHGtYJcVSXuMRZQoc7zidf8i4tYsGG7S348uW+pL9Z0e5Cz72UlL2/IWauFRYGxAPRXXGK+ip1oDGGqjr2DxTVmpae9jBRhg6BdQu2jqRfE8q1ze7q/gCxBRdt2GLd+7HAWjAJAUlOos+qDTXthCrYh9kdUifjmFhxROb9jsY+AnKaTHnOvEGfF5FsACjREkHwfKtlpSXOeaw/ZKX7wv/8i1ks3LyZejZ47KQu2SR+VqmtvTMDz3p0G0823ER/3UJrDNy+mG1ssZzoOfb/huB0QJN2XRgYPACPZJRQwXN4ONGZ/FEj9X0aCgzvVQZCgtYb1m3748aR0otoX5YwLYnyhJ/qbp6z3aAsy8i14BMkPAS+kZ4bH+w6NmZLjUoT7zMfhW5dkjzFkTZfhbzqnGMmk5Bz+erjvGXbFeGfBhvHx2apc2YuuX8uVTMQo40averyjQIMvmnHNIoIepdm77JaeaFYb5GWXG3A4KLptaRitMqLpbPUzO0Dx74WJmlhpSY1Vnyh4BY2/61USq6wLW/S+re6rsR3ksupopBYvETHmsw9QgiuJjLOBbXvPCSpes7TM3i5hFj8IaRPL93Q90dMC0gAnVTnoaXSd0Yu9z7xJQbc244=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2609.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(7696005)(8676002)(66556008)(66476007)(64756008)(110136005)(478600001)(4326008)(76116006)(71200400001)(66946007)(55016002)(66446008)(26005)(186003)(8936002)(83380400001)(53546011)(316002)(5660300002)(86362001)(38100700001)(2906002)(6506007)(52536014)(9686003)(6636002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MHIrRk9YdjdOTnMvUWZvK0VtQ0wrMDBRSGljRXpQOFBmamFOVUUvMkhkSFAw?=
 =?utf-8?B?bU1TejB2cytaUUllZTZuVVhSSVRmdjFoamxvRzFiMTV3QmlQU3VIN2dqYVFP?=
 =?utf-8?B?bHhTcTZ4Vzc4bXoxbnJ0dWM0cTZnV21xa0JLT2VzWFlzSnV2VnpLR0RHVFlG?=
 =?utf-8?B?VEdXY2s3TXlLV0dab1JJNFJTMlY3TnY0M3IzUXc0L0FXZU56a2FHcXB5dXo0?=
 =?utf-8?B?M3Rtelc3b2hkVTNyYytTVUNObE9heEZoWHVEbkswbW01Z1Zqd1RPVWVIdTFZ?=
 =?utf-8?B?eXB3Q1E5YXFDeFJtYU1FWkV2SGVnYWJDQUVGZ2lOMk1JbldKTlZiRzNyU2Jx?=
 =?utf-8?B?YWh3WkF6eWxlOGdCWnN0a3dpcThjRWxVWWVuUDVFOUp0bVZ3YXlsVTFBK2pN?=
 =?utf-8?B?TW9TNjZ1a3B5dUVBREFxenpyR0wrd2FycVJnek9XRTByVTlId1hoSkJBa25v?=
 =?utf-8?B?cWo2amp3NTZJVFJwWmtFZVRMUmtPTVVHeFlydndiQURKeGpETVA2eUFkc2M3?=
 =?utf-8?B?QWdERW9xRUc3V1Y4am45eFgwdUFIc1pNaGtRV09GMTEyck1qUmJUZG9IU3JE?=
 =?utf-8?B?YUx3dXd6enFlM0lwUFIzTm1RdlhhOGVWdDUxd29Kc01TWWtGWTFRYUdYdkxz?=
 =?utf-8?B?UXFjVnpFYjFJMXNTQlBQekpHNDJabFV5emIzbjc4RVd4OE9NbDNVS0F3N3FE?=
 =?utf-8?B?VVFKY3VYVHpabnJJZWVWT2x4WWN4ZFpQbmdNUTBNZFVxK1V2NGxaK2kvcVc2?=
 =?utf-8?B?TFB5WnFXRzZsU3dYZm1uMHBvRDFFaVhzQjcrRmdJUmw3UUhNTnBjd0JYWVNr?=
 =?utf-8?B?QlREL2JqQ2ZIbmpuQkdZMStZSXEwLzJuaERiZGhBYnE4R3RpMWVUcjltYlFO?=
 =?utf-8?B?YWVPMnBWVHY5ZlhjeFg2cGZ3UDBSRllGZDhmVWpaSUM4MWZiSE1pMUI1YXRq?=
 =?utf-8?B?SlRFQUFwY2VUeThUbkhWK2FuNUxNNmx4c0xpSG1QK3pOZ3FDN3BuK296a0dI?=
 =?utf-8?B?L1Y1VW41aUVlMWMyMlNDUWVRZzZGUDVmSm5QUHBUM21CSHVZcjRqMysvd0Zr?=
 =?utf-8?B?ZkJ3Wk9Fc1M2T202bk9lZmNnMlhCSXZ2T0RxUmg5OG1BelkzWkZ1QmpNUWJ3?=
 =?utf-8?B?Lzg5WDR2QjE4WE45WUU4bjV2NzhGYUdLa2hycXhuNk15MXFNMFNVblNWVWVa?=
 =?utf-8?B?b0RhNG52ZDg3VUxtUGV5Ti9STDN6ZG01VXpIY0lVQVRiMkNWVFVrVWd2WmJU?=
 =?utf-8?B?cjY2RzVuOHdvL0JyOVV1Tm9TazlGUmk0N3YzQ3Q5cm16cmIzR2pMZHoreHFH?=
 =?utf-8?B?TG05YzBZTUNGUGQ1bjl3TlJhWG1qNXJBczhLNWZ2MmpvWHNzTHdZN1V6RTBx?=
 =?utf-8?B?OVpDU1UyTzZQMFlzeHIrb2g1bkh6SGtaeHUvTTNnZW53SzdiRDZJcERLWThW?=
 =?utf-8?B?YUoxOTVLT3dRQjk4KzBybkorUE1ZZHNvN28vWWJDbGgwN0k5NnF0UU9Wc0Rj?=
 =?utf-8?B?bHhWOGpiWnlzNktHNTA3QWtSMVhCSkFIVUV0Vnp4SkJ4YjFRMDdUUjJBSEsz?=
 =?utf-8?B?ekd0Nm0vY29hbXduUnNGdnZlL2t1NXcwbUoyeUQzbUpNOE15M1FQSGsyN3Vs?=
 =?utf-8?B?VG9pTzBDRURrQVZISlI0RDNDRDZVNzRwQzEwZEg4bU1DNm1zbG1GWFlCWUl1?=
 =?utf-8?B?ZDVOVFk2RHU4bjZiNGRJT1ppZTZRMWdSbTRnV1R6dzZaYnhjeDBDQmVmSFlX?=
 =?utf-8?Q?hSOU9wcbqw5CYPZubDY1T+oGTI3g1GcddyZS9jD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2609.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddc7fb2-d7f6-425c-97cf-08d8f3215ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 02:13:14.1373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mMcWzxICQMbOW087S17hkt9iU0FQtXLRlzmTMBoB0BPL7mpPlwW4iEuzV6OEzbCoaKAvi3b2HKVmXw4tzoJx5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1394
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29seSBMaSA8Y29seWxp
QHN1c2UuZGU+DQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMjksIDIwMjEgNzoxMCBQTQ0KPiBUbzog
UmVuLCBRaWFvd2VpIDxxaWFvd2VpLnJlbkBpbnRlbC5jb20+OyBNYSwgSmlhbnBlbmcNCj4gPGpp
YW5wZW5nLm1hQGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtiY2gtbnZtLXBhZ2VzIHY3IDMvNl0gYmNhY2hlOiBpbml0aWFsaXph
dGlvbiBvZiB0aGUgYnVkZHkNCj4gDQo+IE9uIDMvMTcvMjEgMTE6MTAgUE0sIFFpYW93ZWkgUmVu
IHdyb3RlOg0KPiA+IEZyb206IEppYW5wZW5nIE1hIDxqaWFucGVuZy5tYUBpbnRlbC5jb20+DQo+
ID4NCj4gPiBUaGlzIG52bSBwYWdlcyBhbGxvY2F0b3Igd2lsbCBpbXBsZW1lbnQgdGhlIHNpbXBs
ZSBidWRkeSB0byBtYW5hZ2UgdGhlDQo+ID4gbnZtIGFkZHJlc3Mgc3BhY2UuIFRoaXMgcGF0Y2gg
aW5pdGlhbGl6ZXMgdGhpcyBidWRkeSBmb3IgbmV3IG5hbWVzcGFjZS4NCj4gPg0KPiA+IHRoZSB1
bml0IG9mIGFsbG9jL2ZyZWUgb2YgdGhlIGJ1ZGR5IGlzIHBhZ2UuIERBWCBkZXZpY2UgaGFzIHRo
ZWlyDQo+ID4gc3RydWN0IHBhZ2UoaW4gZHJhbSBvciBQTUVNKS4NCj4gPg0KPiA+IAlzdHJ1Y3Qg
eyAgICAgICAgLyogWk9ORV9ERVZJQ0UgcGFnZXMgKi8NCj4gPiAJCS8qKiBAcGdtYXA6IFBvaW50
cyB0byB0aGUgaG9zdGluZyBkZXZpY2UgcGFnZSBtYXAuICovDQo+ID4gCQlzdHJ1Y3QgZGV2X3Bh
Z2VtYXAgKnBnbWFwOw0KPiA+IAkJdm9pZCAqem9uZV9kZXZpY2VfZGF0YTsNCj4gPiAJCS8qDQo+
ID4gCQkgKiBaT05FX0RFVklDRSBwcml2YXRlIHBhZ2VzIGFyZSBjb3VudGVkIGFzIGJlaW5nDQo+
ID4gCQkgKiBtYXBwZWQgc28gdGhlIG5leHQgMyB3b3JkcyBob2xkIHRoZSBtYXBwaW5nLCBpbmRl
eCwNCj4gPiAJCSAqIGFuZCBwcml2YXRlIGZpZWxkcyBmcm9tIHRoZSBzb3VyY2UgYW5vbnltb3Vz
IG9yDQo+ID4gCQkgKiBwYWdlIGNhY2hlIHBhZ2Ugd2hpbGUgdGhlIHBhZ2UgaXMgbWlncmF0ZWQg
dG8gZGV2aWNlDQo+ID4gCQkgKiBwcml2YXRlIG1lbW9yeS4NCj4gPiAJCSAqIFpPTkVfREVWSUNF
IE1FTU9SWV9ERVZJQ0VfRlNfREFYIHBhZ2VzIGFsc28NCj4gPiAJCSAqIHVzZSB0aGUgbWFwcGlu
ZywgaW5kZXgsIGFuZCBwcml2YXRlIGZpZWxkcyB3aGVuDQo+ID4gCQkgKiBwbWVtIGJhY2tlZCBE
QVggZmlsZXMgYXJlIG1hcHBlZC4NCj4gPiAJCSAqLw0KPiA+IAl9Ow0KPiA+DQo+ID4gWk9ORV9E
RVZJQ0UgcGFnZXMgb25seSB1c2UgcGdtYXAuIE90aGVyIDQgd29yZHNbMTYvMzIgYnl0ZXNdIGRv
bid0IHVzZS4NCj4gPiBTbyB0aGUgc2Vjb25kL3RoaXJkIHdvcmQgd2lsbCBiZSB1c2VkIGFzICdz
dHJ1Y3QgbGlzdF9oZWFkICcgd2hpY2gNCj4gPiBsaXN0IGluIGJ1ZGR5LiBUaGUgZm91cnRoIHdv
cmQodGhhdCBpcyBub3JtYWwgc3RydWN0IHBhZ2U6OmluZGV4KQ0KPiA+IHN0b3JlIHBnb2ZmIHdo
aWNoIHRoZSBwYWdlLW9mZnNldCBpbiB0aGUgZGF4IGRldmljZS4gQW5kIHRoZSBmaWZ0aA0KPiA+
IHdvcmQgKHRoYXQgaXMgbm9ybWFsIHN0cnVjdCBwYWdlOjpwcml2YXRlKSBzdG9yZSBvcmRlciBv
ZiBidWRkeS4NCj4gPiBwYWdlX3R5cGUgd2lsbCBiZSB1c2VkIHRvIHN0b3JlIGJ1ZGR5IGZsYWdz
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEgPGppYW5wZW5nLm1hQGludGVs
LmNvbT4NCj4gPiBDby1hdXRob3JlZC1ieTogUWlhb3dlaSBSZW4gPHFpYW93ZWkucmVuQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9tZC9iY2FjaGUvbnZtLXBhZ2VzLmMgICB8IDE0
Mg0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICBkcml2ZXJzL21kL2Jj
YWNoZS9udm0tcGFnZXMuaCAgIHwgICA2ICsrDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC9iY2Fj
aGUtbnZtLmggfCAgIDggKysNCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCAxNTIgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNo
ZS9udm0tcGFnZXMuYw0KPiA+IGIvZHJpdmVycy9tZC9iY2FjaGUvbnZtLXBhZ2VzLmMgaW5kZXgg
OTMzNTM3MWM5ZDkxLi4xZjk5OTY1OTIwYTENCj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L21kL2JjYWNoZS9udm0tcGFnZXMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL252bS1w
YWdlcy5jDQo+ID4gQEAgLTQxLDYgKzQxLDEwIEBAIHN0YXRpYyB2b2lkIHJlbGVhc2VfbnZtX25h
bWVzcGFjZXMoc3RydWN0DQo+IGJjaF9udm1fc2V0ICpudm1fc2V0KQ0KPiA+ICAJZm9yIChpID0g
MDsgaSA8IG52bV9zZXQtPnRvdGFsX25hbWVzcGFjZXNfbnI7IGkrKykgew0KPiA+ICAJCW5zID0g
bnZtX3NldC0+bnNzW2ldOw0KPiA+ICAJCWlmIChucykgew0KPiA+ICsJCQlrdmZyZWUobnMtPnBh
Z2VzX2JpdG1hcCk7DQo+ID4gKwkJCWlmIChucy0+cGdhbGxvY19yZWNzX2JpdG1hcCkNCj4gPiAr
CQkJCWJpdG1hcF9mcmVlKG5zLT5wZ2FsbG9jX3JlY3NfYml0bWFwKTsNCj4gPiArDQo+ID4gIAkJ
CWJsa2Rldl9wdXQobnMtPmJkZXYsDQo+IEZNT0RFX1JFQUR8Rk1PREVfV1JJVEV8Rk1PREVfRVhF
Qyk7DQo+ID4gIAkJCWtmcmVlKG5zKTsNCj4gPiAgCQl9DQo+ID4gQEAgLTU1LDE3ICs1OSwxMjIg
QEAgc3RhdGljIHZvaWQgcmVsZWFzZV9udm1fc2V0KHN0cnVjdCBiY2hfbnZtX3NldA0KPiAqbnZt
X3NldCkNCj4gPiAgCWtmcmVlKG52bV9zZXQpOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIHN0
cnVjdCBwYWdlICpudm1fdmFkZHJfdG9fcGFnZShzdHJ1Y3QgYmNoX252bV9uYW1lc3BhY2UgKm5z
LA0KPiA+ICt2b2lkICphZGRyKSB7DQo+ID4gKwlyZXR1cm4gdmlydF90b19wYWdlKGFkZHIpOw0K
PiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCAqbnZtX3Bnb2ZmX3RvX3ZhZGRyKHN0cnVj
dCBiY2hfbnZtX25hbWVzcGFjZSAqbnMsDQo+IHBnb2ZmX3QNCj4gPiArcGdvZmYpIHsNCj4gPiAr
CXJldHVybiBucy0+a2FkZHIgKyAocGdvZmYgPDwgUEFHRV9TSElGVCk7IH0NCj4gPiArDQo+ID4g
K3N0YXRpYyBpbmxpbmUgdm9pZCByZW1vdmVfb3duZXJfc3BhY2Uoc3RydWN0IGJjaF9udm1fbmFt
ZXNwYWNlICpucywNCj4gPiArCQkJCQlwZ29mZl90IHBnb2ZmLCB1MzIgbnIpDQo+ID4gK3sNCj4g
PiArCWJpdG1hcF9zZXQobnMtPnBhZ2VzX2JpdG1hcCwgcGdvZmYsIG5yKTsgfQ0KPiA+ICsNCj4g
PiAgc3RhdGljIGludCBpbml0X293bmVyX2luZm8oc3RydWN0IGJjaF9udm1fbmFtZXNwYWNlICpu
cykgIHsNCj4gPiAgCXN0cnVjdCBiY2hfb3duZXJfbGlzdF9oZWFkICpvd25lcl9saXN0X2hlYWQg
PQ0KPiA+IG5zLT5zYi0+b3duZXJfbGlzdF9oZWFkOw0KPiA+ICsJc3RydWN0IGJjaF9udm1fcGdh
bGxvY19yZWNzICpzeXNfcmVjczsNCj4gPiArCWludCBpLCBqLCBrLCByYyA9IDA7DQo+ID4NCj4g
PiAgCW11dGV4X2xvY2soJm9ubHlfc2V0LT5sb2NrKTsNCj4gPiAgCW9ubHlfc2V0LT5vd25lcl9s
aXN0X2hlYWQgPSBvd25lcl9saXN0X2hlYWQ7DQo+ID4gIAlvbmx5X3NldC0+b3duZXJfbGlzdF9z
aXplID0gb3duZXJfbGlzdF9oZWFkLT5zaXplOw0KPiA+ICAJb25seV9zZXQtPm93bmVyX2xpc3Rf
dXNlZCA9IG93bmVyX2xpc3RfaGVhZC0+dXNlZDsNCj4gPiArDQo+ID4gKwkvKnJlbW92ZSB1c2Vk
IHNwYWNlKi8NCj4gPiArCXJlbW92ZV9vd25lcl9zcGFjZShucywgMCwgbnMtPnBhZ2VzX29mZnNl
dC9ucy0+cGFnZV9zaXplKTsNCj4gPiArDQo+ID4gKwlzeXNfcmVjcyA9IG5zLT5rYWRkciArIEJD
SF9OVk1fUEFHRVNfU1lTX1JFQ1NfSEVBRF9PRkZTRVQ7DQo+ID4gKwkvLyBzdXBwb3NlIG5vIGhv
bGUgaW4gYXJyYXkNCj4gDQo+IFdlIGRvbid0IHVzZSBzdWNoIGNvZGUgY29tbWVudHMgZm9ybWF0
LCBwbGVhc2UgZm9sbG93IHRoZSBjb21tZW50cyBzdHlsZQ0KPiBvZiBleGlzdGluZyBiY2FjaGUg
Y29kZS4NCj4gDQo+IFRoZXJlIGFyZSBhbHNvIG90aGVyIGxvY2F0aW9ucyB1c2luZyAiLy8iIGZv
ciBjb2RlIGNvbW1lbnRzLCB0aGV5IHNob3VsZCBiZQ0KPiBtb2RpZmllZCBhcyB3ZWxsLg0KPiAN
CkdvdCBpdCwgSSdsbCBtb2RpZnkgdGhvc2Ugd3JvbmcgZm9ybWFudCBpbiB0aGUgVjguDQoNClRo
YW5rcyENCkppYW5wZW5nLg0KPiBUaGFua3MuDQo+IA0KPiBDb2x5IExpDQo+IA0KPiANCj4gW3Nu
aXBwZWRdDQo=
