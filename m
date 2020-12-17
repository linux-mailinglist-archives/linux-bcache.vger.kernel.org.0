Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF32DCB56
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Dec 2020 04:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgLQDhH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 22:37:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:9441 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgLQDhH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 22:37:07 -0500
IronPort-SDR: hN2hc6KYxLd67FlMkaxl0NVHz4leBQJJJbs7FOszlD3uqWY1J+P6rRtSAM6BOAvmiKUc05SE5p
 7JxbpWbQQ0WQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="162233727"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="162233727"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 19:36:24 -0800
IronPort-SDR: m5nMPSgYnStO+ORvjtTwLZQQwlUeIFDipqhfardhg0OX8WZBsm3isSNNAOjBQG4ufCsZokkjZf
 CvLL33vjW8xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="488943932"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 16 Dec 2020 19:36:24 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Dec 2020 19:36:24 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Dec 2020 19:36:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Dec 2020 19:36:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 16 Dec 2020 19:36:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AL0IV7ulpkwFdKbpBtwXzUfGE88zp/1gj2mCgBm/sTXaLErVDW0xzRp3FNsDGAitz936uXS2GtVJx3EzhNs5KtIQRVY8t8gX0x6/0JXQobJBcSzw96WydYw0d2HS9XlBo4kTVsc3vYYDnM3cbHm1Ky+3ysgNz/JYfZ9rDj7L+Q/FL7D42+wkXddcMVcmcikQRTy7aUR6FWBMyBi+L8JZNb3po1Sz5cylg2lFaWnRVkVO5BTGZcjvMDp48ydbOw9ge0km53Cntl9tgKz9pa+TS8p3SFIxIH3m4KZEh+O0cBnmjfqBxdYdyPvqaM20kqkJhFi3uATxBZP0SsEpuPM79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fG6nehGPmpoA2dRv5PRcpestvY0q3U7WqduRgNwaTz0=;
 b=T1ayBxjh7WW2WPEQUHgRvePJMlVBuutiDgk9o1zZ68j+rVexMkJqUk6wTdKma0mKasYKrZABBLBwocZPebhYnhZ/a/VhpOUOAtIcwoRkT3huM/6vD4iCTz6EUfQ7Be54CmzaFCCsA88k5/Ix0U9guSFqv7f8CvWqO7dYSEbZ5cEshh0LUhGzgYHN0JroV680WcOCJCGqiOF95Ml6gGpm84gwxnVakMRvXKJ2wpNWKpqO4CdZmPaBsAMu25ncyLaUUnSqAwChtNs/KOG9kNr2Jj3YP/y2wLITy/zmm1sO7KoeCSiW5ONARNaucXVy07PTMI/jPjU8jbeM49HEvURz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fG6nehGPmpoA2dRv5PRcpestvY0q3U7WqduRgNwaTz0=;
 b=GC90U8r2os2kr14mvL4n8TM/1vrkvLN/VRkjuQFDb0DgG8FKhJoswTARA82X0x7EeQYrZLwHFVhdeKJ1xehDFgpJ2CounSvPhg1/S2Cfl7O3K83eB9VACZDnQNz+x8k8WtWgVdhKFWtQDz4pB2AKXOLkzHz2KM68KRhNhtcRIiY=
Received: from BN7PR11MB2609.namprd11.prod.outlook.com (2603:10b6:406:b1::26)
 by BN6PR1101MB2194.namprd11.prod.outlook.com (2603:10b6:405:55::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Thu, 17 Dec
 2020 03:36:22 +0000
Received: from BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::91bc:e770:d1b6:450b]) by BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::91bc:e770:d1b6:450b%3]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 03:36:22 +0000
From:   "Ma, Jianpeng" <jianpeng.ma@intel.com>
To:     Coly Li <colyli@suse.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: RE: [RFC PATCH 3/8] bcache: initialization of the buddy
Thread-Topic: [RFC PATCH 3/8] bcache: initialization of the buddy
Thread-Index: AQHWySHa1ckIyuMryE+miFQf38YMR6n5mqCAgAEecnA=
Date:   Thu, 17 Dec 2020 03:36:22 +0000
Message-ID: <BN7PR11MB26098EAC433883322ECA54BCFDC40@BN7PR11MB2609.namprd11.prod.outlook.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-4-qiaowei.ren@intel.com>
 <3e326a79-a7a4-de3b-c514-3f0b7f7c3cdc@suse.de>
In-Reply-To: <3e326a79-a7a4-de3b-c514-3f0b7f7c3cdc@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bdc3b81-75b5-4549-cff1-08d8a23cece7
x-ms-traffictypediagnostic: BN6PR1101MB2194:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB219424EF28BF212B350E7312FDC40@BN6PR1101MB2194.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K16n41ANajtmQmiPDoDMfd60SqNUTg6/frVZolo9wDSw4ttk1+GwUV8drdXfUCbt77njLJAZcel2VwqEDmhno0tLZSk0u2RFcYXxejeFS3TbUXs7R5fDRQ2VWDdwNxkpMnZ1lvunGQFKlLtiS77JDeq5k19NMaSBURIiHh/XJfjY3d593Vw0CbtUSUT5tKoBIW7WPKQvKcgjyrdPNcz8arWq+hizjfYNA188y+AoDxHtTRvj+BFD9FMIOZJ0gAdfFrd2tPNVvhSQaC6al+LKp/jnbwljKZ7lGqcS11IQJ9qYkrFakoksDui/zvgSfrwRNDoIRGjenaOGJW9LrM8vzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2609.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(110136005)(186003)(71200400001)(5660300002)(66946007)(4326008)(53546011)(52536014)(6636002)(83380400001)(86362001)(8676002)(316002)(55016002)(26005)(76116006)(7696005)(66476007)(8936002)(2906002)(66446008)(6506007)(64756008)(33656002)(66556008)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZHh3MnFIR2VOeS9qUUxLK3l6SktyTEZ5VS9ZdksvZHd4T0N0V0dDVHNZSUhh?=
 =?utf-8?B?YmRVOVBHbzhYYTJMdjNtV1VNSld0THBMYm9zcDJhNVpqM00zL09qaE9XSzJl?=
 =?utf-8?B?M0xDLzZrR3k3K08vWk5lbHUzY0M1QjJsTHZPRWF0V3QvTmM2MlhFaXZ3Q0R2?=
 =?utf-8?B?TGVPdWxQd3NzWFR0dTB1QSttWHJNS3pXbUgrdTBMQklQV0k5bmVsT2xOK2R4?=
 =?utf-8?B?VVMwSmxrR1RQdGxpOTdjRUt4Q3llVjY4YU9QeWJ1MWlUR1pMb1pPOHhBS0Vu?=
 =?utf-8?B?SCt2M0ZVTjBzbWFzekRsYzNvcUxiV0YwUG1yQktMMXI3akZXU1hpbHBIbXRz?=
 =?utf-8?B?aXFOVERYWVcweDFMUjVPVVZaajBUdEdIS0NwUkwvSG9WaWZZd014Qk43VEJS?=
 =?utf-8?B?SW5YOGQzNkUvOHpLMXBQL0lFdlRFQnMzU0FFUGZEdCsxUkZCRWIxNjlGbk5J?=
 =?utf-8?B?a204RHNaSUh1bHpqTExwK25sOWpCTWZ5RU01cEl2YWJLYWEvZVlvOGNFb2FI?=
 =?utf-8?B?QnZTaWFTYTJFbEZjTXZ3MGRyck5ORUk3ZnZqMG9hSnFpNnRyWUd6cW15bVNR?=
 =?utf-8?B?N1FXdkFNK05nd0VVRG00VHVDV3hFMktNUVB5TEpNd3M3eXpQRkhqd1BjR3g2?=
 =?utf-8?B?cEVvU3hFb3pvd3RMQWcyL0hMV3doeWlBanhjTGt3enNKaXFxS1BjbmpCMlFT?=
 =?utf-8?B?MFM4eEhod1VoK1JsRDFEL3Y1N25MR1NjNk8yZHF5dU5FNE5sYjFKRnZrTjNi?=
 =?utf-8?B?cmo3YlR3NW9SM0Z4d2VzN01lVFAyTThOUXhRVGNWaWF4a1BFaFZDWlpNVUtm?=
 =?utf-8?B?QVEvbnRDYWxyc0xSNG8rME9rSHFYSHFlakNjMitHaVRsRGJ0UVFxdUR1WjJv?=
 =?utf-8?B?bXB2V3F0Y1g2Umh3SktkRys4UlFXZG4vTFlobmxCK3hTMzFtVGJsbGtVbkRz?=
 =?utf-8?B?S0tVcGNra1ZIRVMrclMwOG93dFhTZmNoSUpCbkFVcDFwbjYrT2l1UFFLb285?=
 =?utf-8?B?SVlkZ0xvMkxMWFFydjBVSVA0aVdRUFY4eE5Xc1N4ZFdIYTFVdUNXM3hnS1E5?=
 =?utf-8?B?U3NRVHlGN1oyckZabTRDVEFhVlhYNWY2UDNFME8wa2ZYZmw4MG14T0dhTDNP?=
 =?utf-8?B?TTlVcmpSZFd5RWFwQktGMUF4RnhCeWhad3ExNXJyQXNZbU8rbHg5WHJVRWhR?=
 =?utf-8?B?bWtuNElrbnF5WUlOOXBlK3dVWWh1a3pnUEM5VWVVUjRsWTIzV3lwektNU1I1?=
 =?utf-8?B?V2dBYWlBVllURlVSZkc2ZHpjbmFrQnkwT3RIc25mK21icGVDa3BQcnRhTWNt?=
 =?utf-8?Q?6H6R6TbFVozfU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2609.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bdc3b81-75b5-4549-cff1-08d8a23cece7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 03:36:22.7568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxSxIqZUzea86mBh1j7EDUXYvTQrnQ1F4a1tEpwmibzfaZGbdKC5DOAcJAsH8JlqBqM3dhIe53+nbqp19GzauA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2194
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29seSBMaSA8Y29seWxp
QHN1c2UuZGU+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTYsIDIwMjAgNjozMCBQTQ0K
PiBUbzogUmVuLCBRaWFvd2VpIDxxaWFvd2VpLnJlbkBpbnRlbC5jb20+DQo+IENjOiBsaW51eC1i
Y2FjaGVAdmdlci5rZXJuZWwub3JnOyBNYSwgSmlhbnBlbmcgPGppYW5wZW5nLm1hQGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggMy84XSBiY2FjaGU6IGluaXRpYWxpemF0aW9u
IG9mIHRoZSBidWRkeQ0KPiANCj4gT24gMTIvMy8yMCA2OjUzIFBNLCBRaWFvd2VpIFJlbiB3cm90
ZToNCj4gPiBUaGlzIG52bSBwYWdlcyBhbGxvY2F0b3Igd2lsbCBpbXBsZW1lbnQgdGhlIHNpbXBs
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
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBRaWFvd2VpIFJlbiA8cWlhb3dlaS5yZW5AaW50ZWwu
Y29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuYyB8IDY4DQo+
ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgZHJpdmVycy9tZC9i
Y2FjaGUvbnZtLXBhZ2VzLmggfCAgMyArKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDcwIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2JjYWNoZS9udm0tcGFnZXMuYw0KPiA+IGIvZHJpdmVycy9tZC9iY2FjaGUvbnZtLXBhZ2VzLmMg
aW5kZXggODQxNjE2ZWEzMjY3Li43ZmZiZmJhY2FmM2YNCj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbWQvYmNhY2hl
L252bS1wYWdlcy5jDQo+ID4gQEAgLTg0LDYgKzg0LDE3IEBAIHN0YXRpYyB2b2lkICpudm1fcGdv
ZmZfdG9fdmFkZHIoc3RydWN0DQo+IG52bV9uYW1lc3BhY2UgKm5zLCBwZ29mZl90IHBnb2ZmKQ0K
PiA+ICAJcmV0dXJuIG5zLT5rYWRkciArIG5zLT5wYWdlc19vZmZzZXQgKyAocGdvZmYgPDwgUEFH
RV9TSElGVCk7ICB9DQo+ID4NCj4gPiArc3RhdGljIHN0cnVjdCBwYWdlICpudm1fdmFkZHJfdG9f
cGFnZShzdHJ1Y3QgbnZtX25hbWVzcGFjZSAqbnMsIHZvaWQNCj4gPiArKmFkZHIpIHsNCj4gPiAr
CXJldHVybiB2aXJ0X3RvX3BhZ2UoYWRkcik7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBp
bmxpbmUgdm9pZCByZW1vdmVfb3duZXJfc3BhY2Uoc3RydWN0IG52bV9uYW1lc3BhY2UgKm5zLA0K
PiA+ICsJCXBnb2ZmX3QgcGdvZmYsIHUzMiBucikNCj4gPiArew0KPiA+ICsJYml0bWFwX3NldChu
cy0+cGFnZXNfYml0bWFwLCBwZ29mZiwgbnIpOyB9DQo+ID4gKw0KPiA+ICBzdGF0aWMgdm9pZCBp
bml0X293bmVyX2luZm8oc3RydWN0IG52bV9uYW1lc3BhY2UgKm5zKSAgew0KPiA+ICAJc3RydWN0
IG93bmVyX2xpc3RfaGVhZCAqb3duZXJfbGlzdF9oZWFkOyBAQCAtMTI2LDYgKzEzNyw4IEBADQo+
IHN0YXRpYw0KPiA+IHZvaWQgaW5pdF9vd25lcl9pbmZvKHN0cnVjdCBudm1fbmFtZXNwYWNlICpu
cykNCj4gPiAgCQkJCQlleHRlbnQtPm5yID0gcmVjLT5ucjsNCj4gPiAgCQkJCQlsaXN0X2FkZF90
YWlsKCZleHRlbnQtPmxpc3QsICZleHRlbnRzLQ0KPiA+ZXh0ZW50X2hlYWQpOw0KPiA+DQo+ID4g
KwkJCQkJcmVtb3ZlX293bmVyX3NwYWNlKGV4dGVudHMtPm5zLCByZWMtPnBnb2ZmLA0KPiByZWMt
Pm5yKTsNCj4gPiArDQo+ID4gIAkJCQkJZXh0ZW50cy0+bnMtPmZyZWUgLT0gcmVjLT5ucjsNCj4g
PiAgCQkJCX0NCj4gPiAgCQkJCWV4dGVudHMtPnNpemUgKz0gbnZtX3BnYWxsb2NfcmVjcy0+c2l6
ZTsgQEAgLQ0KPiAxNDMsNiArMTU2LDU0IEBADQo+ID4gc3RhdGljIHZvaWQgaW5pdF9vd25lcl9p
bmZvKHN0cnVjdCBudm1fbmFtZXNwYWNlICpucykNCj4gPiAgCW11dGV4X3VubG9jaygmb25seV9z
ZXQtPmxvY2spOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIHZvaWQgaW5pdF9udm1fZnJlZV9z
cGFjZShzdHJ1Y3QgbnZtX25hbWVzcGFjZSAqbnMpIHsNCj4gPiArCXVuc2lnbmVkIGludCBzdGFy
dCwgZW5kLCBpOw0KPiA+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4gKwl1bnNpZ25lZCBpbnQg
cGFnZXM7DQo+ID4gKwlwZ29mZl90IHBnb2ZmX3N0YXJ0Ow0KPiA+ICsNCj4gPiArCWJpdG1hcF9m
b3JfZWFjaF9jbGVhcl9yZWdpb24obnMtPnBhZ2VzX2JpdG1hcCwgc3RhcnQsIGVuZCwgMCwgbnMt
DQo+ID5wYWdlc190b3RhbCkgew0KPiA+ICsJCXBnb2ZmX3N0YXJ0ID0gc3RhcnQ7DQo+ID4gKwkJ
cGFnZXMgPSBlbmQgLSBzdGFydDsNCj4gPiArDQo+ID4gKwkJd2hpbGUgKHBhZ2VzKSB7DQo+ID4g
KwkJCWZvciAoaSA9IE1BWF9PUkRFUiAtIDE7IGkgPj0gMCA7IGktLSkgew0KPiA+ICsJCQkJaWYg
KChzdGFydCAlICgxIDw8IGkpID09IDApICYmIChwYWdlcyA+PSAoMSA8PCBpKSkpDQo+ID4gKwkJ
CQkJYnJlYWs7DQo+ID4gKwkJCX0NCj4gPiArDQo+ID4gKwkJCXBhZ2UgPSBudm1fdmFkZHJfdG9f
cGFnZShucywgbnZtX3Bnb2ZmX3RvX3ZhZGRyKG5zLA0KPiBwZ29mZl9zdGFydCkpOw0KPiA+ICsJ
CQlwYWdlLT5pbmRleCA9IHBnb2ZmX3N0YXJ0Ow0KPiA+ICsJCQlwYWdlLT5wcml2YXRlID0gaTsN
Cj4gPiArCQkJX19TZXRQYWdlQnVkZHkocGFnZSk7DQo+ID4gKwkJCWxpc3RfYWRkKChzdHJ1Y3Qg
bGlzdF9oZWFkICopJnBhZ2UtPnpvbmVfZGV2aWNlX2RhdGEsDQo+ID4gKyZucy0+ZnJlZV9hcmVh
W2ldKTsNCj4gPiArDQo+ID4gKwkJCXBnb2ZmX3N0YXJ0ICs9IDEgPDwgaTsNCj4gPiArCQkJcGFn
ZXMgLT0gMSA8PCBpOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gPiArDQo+ID4gKwliaXRtYXBfZm9y
X2VhY2hfc2V0X3JlZ2lvbihucy0+cGFnZXNfYml0bWFwLCBzdGFydCwgZW5kLCAwLCBucy0NCj4g
PnBhZ2VzX3RvdGFsKSB7DQo+ID4gKwkJcGFnZXMgPSBlbmQgLSBzdGFydDsNCj4gPiArCQlwZ29m
Zl9zdGFydCA9IHN0YXJ0Ow0KPiA+ICsNCj4gPiArCQl3aGlsZSAocGFnZXMpIHsNCj4gPiArCQkJ
Zm9yIChpID0gTUFYX09SREVSIC0gMTsgaSA+PSAwIDsgaS0tKSB7DQo+ID4gKwkJCQlpZiAoKHN0
YXJ0ICUgKDEgPDwgaSkgPT0gMCkgJiYgKHBhZ2VzID49ICgxIDw8IGkpKSkNCj4gPiArCQkJCQli
cmVhazsNCj4gPiArCQkJfQ0KPiA+ICsNCj4gPiArCQkJcGFnZSA9IG52bV92YWRkcl90b19wYWdl
KG5zLCBudm1fcGdvZmZfdG9fdmFkZHIobnMsDQo+IHBnb2ZmX3N0YXJ0KSk7DQo+ID4gKwkJCXBh
Z2UtPmluZGV4ID0gcGdvZmZfc3RhcnQ7DQo+ID4gKwkJCXBhZ2UtPnByaXZhdGUgPSBpOw0KPiA+
ICsNCj4gPiArCQkJcGdvZmZfc3RhcnQgKz0gMSA8PCBpOw0KPiA+ICsJCQlwYWdlcyAtPSAxIDw8
IGk7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiA+ICt9DQo+ID4gKw0KPiANCj4gDQo+IFRoZSBidWRk
eSBzdHJ1Y3R1cmUgc2hvdWxkIGJlIGluaXRpYWxpemVkIGZyb20gdGhlIG93bmVyIGxpc3RzLCB3
ZSBjYW5ub3QNCj4gYXNzdW1lIHRoZSBuYW1lIHNwYWNlIGlzIGVtcHR5LiBCZWNhdXNlIHRoZSB1
c2VyIHNwYWNlIG1heSBhbHNvIGFsbG9jYXRlDQo+IHNwYWNlIGZyb20gTlZESU1NIGV2ZW4gYmVm
b3JlIHRoZSBmaXJzdCB0aW1lIGl0IGlzIGF0dGFjaGVkIGJ5IGtlcm5lbCBkcml2ZXIuDQo+IA0K
SW4gZnVuYyBpbml0X293bmVyX2luZm8sIHdlIGFscmVhZHkgcmVtb3ZlIHRoZSBhbGxvY2VkIHNw
YWNlLg0KDQpUaGFua3MhDQpKaWFucGVuZy4NCj4gDQo+IFtzbmlwcGVkXQ0KPiANCj4gQ29seSBM
aQ0K
