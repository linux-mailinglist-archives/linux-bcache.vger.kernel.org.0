Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375342DCB58
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Dec 2020 04:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgLQDjN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 22:39:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:60689 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgLQDjM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 22:39:12 -0500
IronPort-SDR: hg11eteTXnshUUu/gJp1NN2t+jnXZqA/5vDaY9lMSa2wMskFCuLxhWh3yITEMuVdIQoSG86nKI
 SrYr23CsGZ+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="259906093"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="259906093"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 19:38:31 -0800
IronPort-SDR: 1i2H3gjCdODH1C8Xqy1WvaNtfI18m6XPtCg4rZrdKLQUXFS+cLqUHtZvVOqSU27JGCxePqcytk
 loS+P/jACSAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="488944431"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 16 Dec 2020 19:38:31 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Dec 2020 19:38:30 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Dec 2020 19:38:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Dec 2020 19:38:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 16 Dec 2020 19:38:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGKn/k8LKbLLiSW56OKNDcWbX37zsE+CQAFfFjhfeUAE2a0KEXB6iGemxTHVpdHzR4BhdsyiyJIv+SMV9od6vDFILJFePQ4vCds2DreCve6BPZD+ROiBYpoQgCdlcDyGFMpSPkVDAajMFWBToF080pXBrO3+cXdXXu+6Ui8U/HRMgMFEm00O7XCURrtmt7LoX+10+LmTG9z3141LnHiiDU7K6KWuhkUdZx7D4QNxY4zj5vcyDa7vd1S06NsvUJrbOAxj1RlY5niC3r1H3xQP3YElsezspEh/+JCVjnV7zF/3wTRteWYZ6LrqpMzsc6KuqyhVZCHOP1uJesyzpEGaZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxDP4WiAtzzIqGUQntwYbrjBEL2xPgm8koNQEt7Yw4o=;
 b=EbXlQfVoP2dnHLbLPWp3gUPGH8pqOW6B2COApmlOV39j/VOLqOT6o0tsO3bLA0zy+sXUkYeiVhKquAyXUaIXxTQ+QvPHClyREw5fxYrQDVty7+C0vtcfHHOBMAazGMxf9b7IU68YzzepXZAnIsxf/e/rniR1KH1eFNNL0hHS0n/AwHo8bInKWqlOeaVhHfQSmAlRE42lksr+NSjkQE/sf4Tl80O5rKbkMSaXFP3EexmEcJhJx3pnEX/2cAux0xMgUiAmGMSX0xOO60duAstw1//Zt29JV+cZc6aE1ViZlnvGSmfB5zdq92xuDiV3fynZwPHD89b3S5n48Ut4+5L6NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxDP4WiAtzzIqGUQntwYbrjBEL2xPgm8koNQEt7Yw4o=;
 b=UiCUSUVLwk1ais4UqkrU9khOEDNmbiQb+PtMv4RRWS4qHSlBxcdirFJGJACrNDxTj4xOvKin036sXdAHWztbkRi2uXk/RGuUVaPqEHqLPoCOUxoF2gyPyrwxugq5k9cbG94fSc3NzPXA9cqthKcHMX4chD+lKAH7xaZidd0q3iM=
Received: from BN7PR11MB2609.namprd11.prod.outlook.com (2603:10b6:406:b1::26)
 by BN6PR1101MB2194.namprd11.prod.outlook.com (2603:10b6:405:55::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Thu, 17 Dec
 2020 03:38:28 +0000
Received: from BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::91bc:e770:d1b6:450b]) by BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::91bc:e770:d1b6:450b%3]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 03:38:28 +0000
From:   "Ma, Jianpeng" <jianpeng.ma@intel.com>
To:     Coly Li <colyli@suse.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: RE: [RFC PATCH 7/8] bcache: persist owner info when alloc/free pages.
Thread-Topic: [RFC PATCH 7/8] bcache: persist owner info when alloc/free
 pages.
Thread-Index: AQHWySHbj4aybhHhRE2Wz8lsoPGkHqn5oBGAgAEZbVA=
Date:   Thu, 17 Dec 2020 03:38:28 +0000
Message-ID: <BN7PR11MB2609DE7063A818090F3A9002FDC40@BN7PR11MB2609.namprd11.prod.outlook.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-8-qiaowei.ren@intel.com>
 <275018af-373f-df0c-bf53-1148a8e250e2@suse.de>
In-Reply-To: <275018af-373f-df0c-bf53-1148a8e250e2@suse.de>
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
x-ms-office365-filtering-correlation-id: 2ace4487-d351-4590-81a6-08d8a23d37f0
x-ms-traffictypediagnostic: BN6PR1101MB2194:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2194E2ABFF5351F506573575FDC40@BN6PR1101MB2194.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hFzPjU8O1rHs2YPWG5z5IX1SyV4CZxu0+Osto+roEjBY4d+DAX+93dcvijlLhN/hKIHxIguIVwTduXXHoNmJcpNHSEaYcTDGV8D49JYhiWYTd78B96YZQXZB/h7Qh4UNJEhiwGxKBOFBgT/sUyr1y8rEA1PKzquQpV7TUQyz8M5DCdYTwpysH9u9mx2RHPwwjMFdtXG37e0FJ10xSwAXy8SVIbNVZPnMLzl2VK/QciFDuJOazB69N8BfpzKfnN9v658x2vaU/wKJNSTdMUnR4/qbUKFR19vKVs7wIlqzpkyhcsHmGE7xsoKcwOjkZsoO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2609.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(66476007)(2906002)(8936002)(7696005)(316002)(55016002)(26005)(76116006)(66446008)(64756008)(33656002)(66556008)(9686003)(478600001)(6506007)(71200400001)(5660300002)(53546011)(66946007)(4326008)(186003)(110136005)(83380400001)(86362001)(8676002)(52536014)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UHU2dElZMmZTQ3FtMjhjaWdESGN1RFd1VndEY0ZjN3lnL0lDTDM1dUY5VWNs?=
 =?utf-8?B?Q3pGYURHZ1NUNndJalhIdHdPWmRUYi9pajFFWHJtbFJRbUU5RFFVbllLVDVw?=
 =?utf-8?B?UEFKb01wcmFtOS81dDJUeGVJdTk1b2lEK2x5MVVLY3E3QTNiOXRnY1lDR0lE?=
 =?utf-8?B?WWxxRjVXSFJTQXQ4d3YzSkZtN21iWU9CeU43RnV4KzErTWhLWUUrUUFsU2xr?=
 =?utf-8?B?TS9pNTF4TE1yN3BYdFhnRU1mYUhEc1FhRzlJTnlvU2hlV0VkRG9WTllsZEo0?=
 =?utf-8?B?K0pETlFkV2cvVnhOcXpHQm8yS2xUcWEvdGhWeUd4MHUxRkNkUFpqYy9xdHlS?=
 =?utf-8?B?QzlGZ2o1QTZCWFh4YlFQWlYxTEVHdEkwYjlzVFNKSStjbUlCTW5ZTHk4Wk1j?=
 =?utf-8?B?UXlnZVIxV0t1NkNZR0tjdndVd2JZb3huaVRqKzloWldock44QWNzeEFGYTQr?=
 =?utf-8?B?N0NhTTZjVVRDdFlpOGQ5ZjExaVl3OGtOWnRLOFJDV0xoNjRZMzR1NWJuU0hH?=
 =?utf-8?B?WlA0V3BIQlp3M05xbEhFRm1FOXlLdHRuaFhiYzdxY05mUitTOHpwMVJxcFR4?=
 =?utf-8?B?TTVTWXczZ2dXY0dNVEZva3RNNHpTQmMwZi9IWlVtdUxiY01kNDd6KzlwNEhV?=
 =?utf-8?B?RUpkYzhtUmVCRzZwRThrT0U3a1I5Z0RCbGlPTlpVWktia3huT05hVXZtYXht?=
 =?utf-8?B?NUJ4d2pGcXBkTFdRVTQwbVU2Rkt0Zk5kMldJekU0VitKY3dOcUJBdGRaclRJ?=
 =?utf-8?B?Rm1KS2hXemFzSFYrb1BlOU9jb3lBWFBnaDdnNzZ1VlZ6ZFNnQlZORjROTHF4?=
 =?utf-8?B?NXdCbnJXemtrS0lKSEVINzc3RVV1OG1ZVWQ2S3I3WGlGaTdjd0pRT2d1M2I1?=
 =?utf-8?B?TDN1Sy8yZTdwSUFFTHR1Q1Y0bnoxdElMUkFmaHcxQVNKeVFreGRwcyt5SnZ0?=
 =?utf-8?B?L0tzUnpSYzNJZXNOdysyUWY3QzMwNTVGVHBpU0J2Q2xpTnZDMXE5WGhYekRS?=
 =?utf-8?B?eEdDY01HR0lZQkxVZHBIQnB6elpud00yNy9HZHNxeUdLQ3NhMndzYUdGcjI5?=
 =?utf-8?B?aGt5ajM2ZGtpTHdxVUhMNE1iUGdHYUU4Ynk5Zmsvc3d1MWNwOXFDWStDN2Ru?=
 =?utf-8?B?eVdsMXZiZW10YmNPV1hhRzJxMFRpY2lpa0J0bTBRcjJUQi8xT2lsdStzZ2dI?=
 =?utf-8?B?Q1NWUHlQeUdEYTNvT0ZHV1ZBNjlSaDZZRSt6RCtTejFpNWQ4cEJwRVZMbzZz?=
 =?utf-8?B?L3FQbnNrS1JCYTROZkx3cHpNakFuTXB0Z25RQlVwa0h2clAyUVhKczhHcEFL?=
 =?utf-8?Q?VgrUS9ZX8XyVU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2609.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ace4487-d351-4590-81a6-08d8a23d37f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 03:38:28.6909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXF2XJZC0SQPX7uAk6dvypb3/J7YC+Cd4IQv68wOrD5iDqe6dqqPrBkUKgH7A6jLVa1/mkE6c0I+hvbvYGenQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2194
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29seSBMaSA8Y29seWxp
QHN1c2UuZGU+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTYsIDIwMjAgNjo1MCBQTQ0K
PiBUbzogUmVuLCBRaWFvd2VpIDxxaWFvd2VpLnJlbkBpbnRlbC5jb20+DQo+IENjOiBsaW51eC1i
Y2FjaGVAdmdlci5rZXJuZWwub3JnOyBNYSwgSmlhbnBlbmcgPGppYW5wZW5nLm1hQGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggNy84XSBiY2FjaGU6IHBlcnNpc3Qgb3duZXIg
aW5mbyB3aGVuIGFsbG9jL2ZyZWUNCj4gcGFnZXMuDQo+IA0KPiBPbiAxMi8zLzIwIDY6NTMgUE0s
IFFpYW93ZWkgUmVuIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggaW1wbGVtZW50IHBlcnNpc3Qgb3du
ZXIgaW5mbyBvbiBudmRpbW0gZGV2aWNlIHdoZW4NCj4gPiBhbGxvYy9mcmVlIHBhZ2VzLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEgPGppYW5wZW5nLm1hQGludGVsLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBRaWFvd2VpIFJlbiA8cWlhb3dlaS5yZW5AaW50ZWwuY29tPg0K
PiANCj4gUmV2aXdlZC1ieTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+DQo+IA0KPiANCj4gVGhp
cyBwYXRjaCBjYW4gYmUgaW1wcm92ZWQsIGJ1dCB0aGUgY3VycmVudCBzaGFwZSBpcyBPSyB0byBt
ZSBhcyBhIHN0YXJ0Lg0KPiANClllcywgIGluIGZhY3Qgd2UgbmVlZCB0d28gZnVuY3Rpb246IG9u
ZSB3aGljaCBzeW5jIGFsbCBvd25lciBsaXN0IGFuZCBvbmUgb25seSBzeW5jIG9uZSBvd25lcl9s
aXN0IGJ5IG93bmVyX3V1aWQuDQoNClRoYW5rcyENCkppYW5wZW5nLg0KPiBUaGFua3MuDQo+IA0K
PiBDb2x5IExpDQo+IA0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMu
YyB8IDg2DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDg2IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuYw0KPiA+IGIvZHJpdmVycy9tZC9iY2FjaGUvbnZtLXBh
Z2VzLmMgaW5kZXggZTg3NjViMGIzMzk4Li5iYTFmZjA1ODJiMjANCj4gPiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbWQv
YmNhY2hlL252bS1wYWdlcy5jDQo+ID4gQEAgLTE5Nyw2ICsxOTcsMTcgQEAgc3RhdGljIHN0cnVj
dCBudm1fbmFtZXNwYWNlDQo+ICpmaW5kX252bV9ieV9hZGRyKHZvaWQgKmFkZHIsIGludCBvcmRl
cikNCj4gPiAgCXJldHVybiBOVUxMOw0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIHZvaWQgaW5p
dF9wZ2FsbG9jX3JlY3Moc3RydWN0IG52bV9wZ2FsbG9jX3JlY3MgKnJlY3MsIGNvbnN0DQo+ID4g
K2NoYXIgKm93bmVyX3V1aWQpIHsNCj4gPiArCW1lbXNldChyZWNzLCAwLCBzaXplb2Yoc3RydWN0
IG52bV9wZ2FsbG9jX3JlY3MpKTsNCj4gPiArCW1lbWNweShyZWNzLT5vd25lcl91dWlkLCBvd25l
cl91dWlkLCAxNik7IH0NCj4gPiArDQo+ID4gK3N0YXRpYyBwZ29mZl90IHZhZGRyX3RvX252bV9w
Z29mZihzdHJ1Y3QgbnZtX25hbWVzcGFjZSAqbnMsIHZvaWQNCj4gPiArKmthZGRyKSB7DQo+ID4g
KwlyZXR1cm4gKGthZGRyIC0gbnMtPmthZGRyIC0gbnMtPnBhZ2VzX29mZnNldCkgLyBQQUdFX1NJ
WkU7IH0NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgcmVtb3ZlX2V4dGVudChzdHJ1Y3QgbnZtX2Fs
bG9jZWRfcmVjcyAqYWxsb2NlZF9yZWNzLCB2b2lkDQo+ID4gKmFkZHIsIGludCBvcmRlcikgIHsN
Cj4gPiAgCXN0cnVjdCBsaXN0X2hlYWQgKmxpc3QgPSBhbGxvY2VkX3JlY3MtPmV4dGVudF9oZWFk
Lm5leHQ7IEBAIC0yNzUsNg0KPiA+ICsyODYsNzcgQEAgc3RhdGljIHZvaWQgX19mcmVlX3NwYWNl
KHN0cnVjdCBudm1fbmFtZXNwYWNlICpucywgdm9pZA0KPiAqYWRkciwgaW50IG9yZGVyKQ0KPiA+
ICAJbnMtPmZyZWUgKz0gYWRkX3BhZ2VzOw0KPiA+ICB9DQo+ID4NCj4gPiArI2RlZmluZSBSRUNT
X0xFTiAoc2l6ZW9mKHN0cnVjdCBudm1fcGdhbGxvY19yZWNzKSkNCj4gPiArDQo+ID4gK3N0YXRp
YyB2b2lkIHdyaXRlX293bmVyX2luZm8odm9pZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IG93bmVy
X2xpc3QgKm93bmVyX2xpc3Q7DQo+ID4gKwlzdHJ1Y3QgbnZtX3BhZ2VzX293bmVyX2hlYWQgKm93
bmVyX2hlYWQ7DQo+ID4gKwlzdHJ1Y3QgbnZtX3BnYWxsb2NfcmVjcyAqcmVjczsNCj4gPiArCXN0
cnVjdCBleHRlbnQgKmV4dGVudDsNCj4gPiArCXN0cnVjdCBudm1fbmFtZXNwYWNlICpucyA9IG9u
bHlfc2V0LT5uc3NbMF07DQo+ID4gKwlzdHJ1Y3Qgb3duZXJfbGlzdF9oZWFkICpvd25lcl9saXN0
X2hlYWQ7DQo+ID4gKwlib29sIHVwZGF0ZV9vd25lciA9IGZhbHNlOw0KPiA+ICsJdTY0IHJlY3Nf
cG9zID0gTlZNX1BBR0VTX1NZU19SRUNTX0hFQURfT0ZGU0VUOw0KPiA+ICsJc3RydWN0IGxpc3Rf
aGVhZCAqbGlzdDsNCj4gPiArCWludCBpLCBqOw0KPiA+ICsNCj4gPiArCW93bmVyX2xpc3RfaGVh
ZCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBvd25lcl9saXN0X2hlYWQpLA0KPiBHRlBfS0VSTkVM
KTsNCj4gPiArCXJlY3MgPSBrbWFsbG9jKFJFQ1NfTEVOLCBHRlBfS0VSTkVMKTsNCj4gPiArDQo+
ID4gKwkvLyBpbi1tZW1vcnkgb3duZXIgbWF5YmUgbm90IGNvbnRhaW4gYWxsb2NlZC1wYWdlcy4N
Cj4gPiArCWZvciAoaSA9IDA7IGkgPCBvbmx5X3NldC0+b3duZXJfbGlzdF9zaXplOyBpKyspIHsN
Cj4gPiArCQlvd25lcl9oZWFkID0gJm93bmVyX2xpc3RfaGVhZC0+aGVhZHNbb3duZXJfbGlzdF9o
ZWFkLQ0KPiA+c2l6ZV07DQo+ID4gKwkJb3duZXJfbGlzdCA9IG9ubHlfc2V0LT5vd25lcl9saXN0
c1tpXTsNCj4gPiArDQo+ID4gKwkJZm9yIChqID0gMDsgaiA8IG9ubHlfc2V0LT50b3RhbF9uYW1l
c3BhY2VzX25yOyBqKyspIHsNCj4gPiArCQkJc3RydWN0IG52bV9hbGxvY2VkX3JlY3MgKmV4dGVu
dHMgPSBvd25lcl9saXN0LQ0KPiA+YWxsb2NlZF9yZWNzW2pdOw0KPiA+ICsNCj4gPiArCQkJaWYg
KCFleHRlbnRzIHx8ICFleHRlbnRzLT5zaXplKQ0KPiA+ICsJCQkJY29udGludWU7DQo+ID4gKw0K
PiA+ICsJCQlpbml0X3BnYWxsb2NfcmVjcyhyZWNzLCBvd25lcl9saXN0LT5vd25lcl91dWlkKTsN
Cj4gPiArDQo+ID4gKwkJCUJVR19PTihyZWNzX3BvcyA+PSBOVk1fUEFHRVNfT0ZGU0VUKTsNCj4g
PiArCQkJb3duZXJfaGVhZC0+cmVjc1tqXSA9IChzdHJ1Y3QgbnZtX3BnYWxsb2NfcmVjcw0KPiAq
KXJlY3NfcG9zOw0KPiA+ICsNCj4gPiArCQkJZm9yIChsaXN0ID0gZXh0ZW50cy0+ZXh0ZW50X2hl
YWQubmV4dDsNCj4gPiArCQkJCWxpc3QgIT0gJmV4dGVudHMtPmV4dGVudF9oZWFkOw0KPiA+ICsJ
CQkJbGlzdCA9IGxpc3QtPm5leHQpIHsNCj4gPiArCQkJCWV4dGVudCA9IGNvbnRhaW5lcl9vZihs
aXN0LCBzdHJ1Y3QgZXh0ZW50LCBsaXN0KTsNCj4gPiArDQo+ID4gKwkJCQlpZiAocmVjcy0+c2l6
ZSA9PSBNQVhfUkVDT1JEKSB7DQo+ID4gKwkJCQkJQlVHX09OKHJlY3NfcG9zID49IE5WTV9QQUdF
U19PRkZTRVQpOw0KPiA+ICsJCQkJCXJlY3MtPm5leHQgPQ0KPiA+ICsJCQkJCQkoc3RydWN0IG52
bV9wZ2FsbG9jX3JlY3MgKikocmVjc19wb3MgKw0KPiBSRUNTX0xFTik7DQo+ID4gKwkJCQkJbWVt
Y3B5X2ZsdXNoY2FjaGUobnMtPmthZGRyICsgcmVjc19wb3MsDQo+IHJlY3MsIFJFQ1NfTEVOKTsN
Cj4gPiArCQkJCQlpbml0X3BnYWxsb2NfcmVjcyhyZWNzLCBvd25lcl9saXN0LQ0KPiA+b3duZXJf
dXVpZCk7DQo+ID4gKwkJCQkJcmVjc19wb3MgKz0gUkVDU19MRU47DQo+ID4gKwkJCQl9DQo+ID4g
Kw0KPiA+ICsJCQkJcmVjcy0+cmVjc1tyZWNzLT5zaXplXS5wZ29mZiA9DQo+ID4gKwkJCQkJdmFk
ZHJfdG9fbnZtX3Bnb2ZmKG9ubHlfc2V0LT5uc3Nbal0sIGV4dGVudC0NCj4gPmthZGRyKTsNCj4g
PiArCQkJCXJlY3MtPnJlY3NbcmVjcy0+c2l6ZV0ubnIgPSBleHRlbnQtPm5yOw0KPiA+ICsJCQkJ
cmVjcy0+c2l6ZSsrOw0KPiA+ICsJCQl9DQo+ID4gKw0KPiA+ICsJCQl1cGRhdGVfb3duZXIgPSB0
cnVlOw0KPiA+ICsJCQltZW1jcHlfZmx1c2hjYWNoZShucy0+a2FkZHIgKyByZWNzX3BvcywgcmVj
cywNCj4gUkVDU19MRU4pOw0KPiA+ICsJCQlyZWNzX3BvcyArPSBzaXplb2Yoc3RydWN0IG52bV9w
Z2FsbG9jX3JlY3MpOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJaWYgKHVwZGF0ZV9vd25lcikg
ew0KPiA+ICsJCQltZW1jcHkob3duZXJfaGVhZC0+dXVpZCwgb3duZXJfbGlzdC0+b3duZXJfdXVp
ZCwNCj4gMTYpOw0KPiA+ICsJCQlvd25lcl9saXN0X2hlYWQtPnNpemUrKzsNCj4gPiArCQkJdXBk
YXRlX293bmVyID0gZmFsc2U7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCW1lbWNw
eV9mbHVzaGNhY2hlKG5zLT5rYWRkciArDQo+IE5WTV9QQUdFU19PV05FUl9MSVNUX0hFQURfT0ZG
U0VULA0KPiA+ICsJCQkJKHZvaWQgKilvd25lcl9saXN0X2hlYWQsIHNpemVvZihzdHJ1Y3QNCj4g
b3duZXJfbGlzdF9oZWFkKSk7DQo+ID4gKwlrZnJlZShvd25lcl9saXN0X2hlYWQpOw0KPiA+ICt9
DQo+ID4gKw0KPiA+ICB2b2lkIG52bV9mcmVlX3BhZ2VzKHZvaWQgKmFkZHIsIGludCBvcmRlciwg
Y29uc3QgY2hhciAqb3duZXJfdXVpZCkgIHsNCj4gPiAgCXN0cnVjdCBudm1fbmFtZXNwYWNlICpu
czsNCj4gPiBAQCAtMzA5LDYgKzM5MSw3IEBAIHZvaWQgbnZtX2ZyZWVfcGFnZXModm9pZCAqYWRk
ciwgaW50IG9yZGVyLCBjb25zdA0KPiBjaGFyICpvd25lcl91dWlkKQ0KPiA+ICAJfQ0KPiA+DQo+
ID4gIAlfX2ZyZWVfc3BhY2UobnMsIGFkZHIsIG9yZGVyKTsNCj4gPiArCXdyaXRlX293bmVyX2lu
Zm8oKTsNCj4gPg0KPiA+ICB1bmxvY2s6DQo+ID4gIAltdXRleF91bmxvY2soJm9ubHlfc2V0LT5s
b2NrKTsNCj4gPiBAQCAtMzY4LDcgKzQ1MSwxMCBAQCB2b2lkICpudm1fYWxsb2NfcGFnZXMoaW50
IG9yZGVyLCBjb25zdCBjaGFyDQo+ICpvd25lcl91dWlkKQ0KPiA+ICAJCX0NCj4gPiAgCX0NCj4g
Pg0KPiA+ICsJaWYgKGthZGRyKQ0KPiA+ICsJCXdyaXRlX293bmVyX2luZm8oKTsNCj4gPiAgCW11
dGV4X3VubG9jaygmb25seV9zZXQtPmxvY2spOw0KPiA+ICsNCj4gPiAgCXJldHVybiBrYWRkcjsN
Cj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChudm1fYWxsb2NfcGFnZXMpOw0KPiA+DQoN
Cg==
