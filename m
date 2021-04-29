Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8236E268
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Apr 2021 02:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhD2AOj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 20:14:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:3656 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhD2AOi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 20:14:38 -0400
IronPort-SDR: 8ZAeSFz5S1glyQnQZKs5aqgh9+YgoqFOMHt1A/ZVeiGeITcrmerGk+65cqkM+jc6WmuZk4kKkX
 5vBJuuiTzRQw==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="260833852"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="260833852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 17:13:52 -0700
IronPort-SDR: 3x4NKeh2zcHyPW9uWFuc2eA3FN035f38XC1M26zJVffF0O5EepaIXl0bZbgoYQrsObhUOmz12K
 lyrxm+j3OxqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="430573176"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2021 17:13:52 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 28 Apr 2021 17:13:51 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 28 Apr 2021 17:13:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 28 Apr 2021 17:13:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 28 Apr 2021 17:13:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dydTHHjd8NRFDoohIANfUVF22LoVefuTJIUjxt1A60GEwx5i/N2tosEpjhREEgy1T8PLEpEys2V6CY9SzJuHEVDe1a+VIDQHNeSH3RQ3/lqL9Ea09Qvqa25PKqrJzS9rfY2IncSvYPvS5mYMclZzzxHVMYWBP0++PvQGEBbf0ebFAZzlQlQy0JaXZSx89OIjNnfiujy3ORQ+jw5pAaHoHjdgjTbvNy0vCz/n5O9DqlR8T/bPsJmGzafNRZFgn8rms7x13SrBzjoYDP3DjvL0yV/YuKWaU0xus0O2pvHHJkdfrAO7rijsj8a4GicAE6HHsOwphk7gp0Pwjd5J3uHamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwLhWRpfFSWkZ8Qyre7LcoIyuWgZezUWgphPeLWzgWQ=;
 b=BMgKYdD8PwKmj9AcpbZFHMgger+3WAI4ql6nvZwVZs3i/CcZmi5Gs14eQnXw6erajAFpO3djrTuZz4zkUYpVKjune8P5kf8EHJnjLndM5tURzPWPnW8BNfd0cHr8/fiXq6nZFfZTvhtMiq6wg26mmq+fcSdyidVTBpWQccCChWHMAVot7WfkapaGQQKPBO8F3SCaXwwCgGMAp/HMIVcXEpoGyAcUBRRB97+N8usWQ7KyF5K2LWoAFrRHwPSiM+5k70u84RpH7vkAP0ccyVxGQux9jJiaNleO8zE2USBDRo+1txACWuTii464VkZhjHEYhEOE4wXEwoZ1JQVwZBqsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwLhWRpfFSWkZ8Qyre7LcoIyuWgZezUWgphPeLWzgWQ=;
 b=EJ+aErQEdif2pzAVDHHrjo7L/klKeP2PBT3ZR4nkHQTnXlxcvS7ka2iKtvNUhL53N6+wZ7X49Okmb3/tQO0hiQeFoiOKtQHMALVTayIUnCm+/bGcbisLQagbolTRmWxGLcCUj5nnkxaH07skz9jFpOszb4rm0dwXDCj8kAgtWoA=
Received: from BN7PR11MB2609.namprd11.prod.outlook.com (2603:10b6:406:b1::26)
 by BN8PR11MB3714.namprd11.prod.outlook.com (2603:10b6:408:90::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 00:13:46 +0000
Received: from BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::61bb:c32e:75d0:d5ed]) by BN7PR11MB2609.namprd11.prod.outlook.com
 ([fe80::61bb:c32e:75d0:d5ed%7]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 00:13:46 +0000
From:   "Ma, Jianpeng" <jianpeng.ma@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "colyli@suse.de" <colyli@suse.de>,
        "rdunlap@infradead.oom" <rdunlap@infradead.oom>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [bch-nvm-pages v9 2/6] bcache: initialize the nvm pages allocator
Thread-Topic: [bch-nvm-pages v9 2/6] bcache: initialize the nvm pages
 allocator
Thread-Index: AQHXPDciI3P3KYBvtUW+Rn3dZCv8UqrKHuwAgACBW1A=
Date:   Thu, 29 Apr 2021 00:13:46 +0000
Message-ID: <BN7PR11MB26097300B6C87684C712CE7DFD5F9@BN7PR11MB2609.namprd11.prod.outlook.com>
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-3-qiaowei.ren@intel.com>
 <779bb3fb-ad1c-35d0-c43d-b25d39200570@infradead.org>
In-Reply-To: <779bb3fb-ad1c-35d0-c43d-b25d39200570@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7183502b-6abc-4c8c-8ffe-08d90aa3a7e4
x-ms-traffictypediagnostic: BN8PR11MB3714:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37143264A4BD9D4308BFF927FD5F9@BN8PR11MB3714.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MBjkrnNJwjCg8V+U8pqODJb9/YZmrdxYYq+k/IuCJRPwotygEaEEBp35Ar60ETJl3oIEORCYHiy/tfhyvVCSmO8+xV5GOGJtlmJiAKX75elI1E3/cKMT6+4bqF2+Je5YGXt6GDajauLpdgZQjrhZFQgGKyURo98c7eSuV4c2pw/ge9Q9zGyfpht3B3V+sPQv0Yio+sO0yuFTEU+0U3j69xjjGFeFAYp+c/0YWX4UfC+PKyXbecn1dCnDfQnji3h6kHbGuv0rVqoQXWrWoVp0ZxkYCKdFbp5CnmTGuJJoE523GAPTGAfCY2ofn3Hcms81NwfcGB+IdznfkBm+HEmMUEueOP3Vn17szvQ9KN2dIc/nvUX3IdcoIHkaD4HST1edZsZWNxFpFwOfuU1mO0vaFFtp1BoMA8yghfErmCrJJwfmIBE2bzqPi7IwYKrRyVLWdocbl4JjQaFjsH41nFaSI4GHUn0v/4Zr/7VFitmiDYK/9sCupWf8r33hqvOX+8VyB6xLFRR51Tn1ls4tjCfwLPUA/6eHoV/gCAM3VjboVvwQgyXoCOsr746FCAy0E18OmBWxqq8igkRD5HYD51kjdygsyM7QgxdsxW3Dr0psDmE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2609.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(136003)(346002)(8936002)(316002)(122000001)(83380400001)(478600001)(2906002)(7696005)(186003)(110136005)(66476007)(66446008)(55016002)(6506007)(66556008)(9686003)(64756008)(76116006)(66946007)(5660300002)(4326008)(26005)(8676002)(33656002)(86362001)(54906003)(52536014)(53546011)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bFhkSVMxMlB6ZFFwekZYbEczRzh5d0xXeExjWWVMVTRvSzZaL0NjTWx4eG5t?=
 =?utf-8?B?d1VaTGtCM2s5YmhnRjVINUR3MmxDVkVFRFlHNi9UcFpDK3BtM2pnTk1kYW43?=
 =?utf-8?B?QjRTVkhpOGNBdGNMZ0U5TUl3TjQ1NjBPNjZtSkkvZy9TR2FxQmJKVi9GT1dV?=
 =?utf-8?B?WWFYbnl6aWY3ditTQThJYWpyemEvbHhVSnBRMlJ1OVQ0eE9UdUhFZm00d3hu?=
 =?utf-8?B?aGVEVFZJNUY3eEZtcWZWazI3UXVkV3lXZk50WldlMk90TTZUcVZ5UHN2bno5?=
 =?utf-8?B?U0RnU1daM1ZSb1RjbGpuVy9QMUlBaEc5M201Ymp0azN3TzZEQVdiZzFnRFl4?=
 =?utf-8?B?WE42OUxXVW9QZ0JqQXNxeFY2YlF4TEo0dGRUYVRTWURrbnFHYk5Sc0R6NFJ3?=
 =?utf-8?B?bHF5N2NOK2MwVjh1WDArNkxrUHdCU3lEK2ZJaXVlMzIzaCtqQ0lCN3RrYjVW?=
 =?utf-8?B?Vmpad1BFL0hsLzFUMzN1cVF1eG5xdHZJWGNISDlhMG8wVi9rdjdyMS9VaFlh?=
 =?utf-8?B?aG9JUkFFRE9wSmZzOWVkTGFZWllUS0lPZUdrRnJBU3kwNW5xZTVFeFQ5WitM?=
 =?utf-8?B?NUpUV0Vtd3ZNamQrdnNZTEExcTc3R3ViU1RnRklDWlQwOFpwZ3p2Ukh5MHdL?=
 =?utf-8?B?MnVmVUhvWTRsNzlGM21vYWpxTlduc2srMUx3QU1yUHZzamxKUVp6TzBIbnkz?=
 =?utf-8?B?MytRclhXMkRielo0akpvS1pjZ0JkK2pRNDZRQ2lMU3dHUkRvN05KbG5neFhs?=
 =?utf-8?B?dUtobUkyWTVhcmVaenkyZEpjREFZdG1Qdy9EUjF5Y0dLd3RlNzQ1bFpBa0Er?=
 =?utf-8?B?SXYrbjhvQ0YwRWJEN0R3bjFXYUZkK3V6Lys0OGFURHVnNUxEdFlzQlZCa1lK?=
 =?utf-8?B?eXhSK2JoWWllMEczSFM4YUMvdEJML2psaHVsMkRHOHpiMWhreFRvQ1psYlpM?=
 =?utf-8?B?TnVORTdzSEQxU0JtRlNVT3lPMk1ubWIxbXB0K0t6NFdhbmRmclZ5Y2I3MGNY?=
 =?utf-8?B?UUkyNVlJS3hGYmZGN1hRVGZHSzZoajR0dVJab3B0NEUvMUwrZFYzcDQ0b3ZY?=
 =?utf-8?B?SnloWjVYekRQU0ZiUW1JeHh5SXVvQy8yOFAyT0tVZ2dyZ3RaQXo5SEdQYWpq?=
 =?utf-8?B?Uy9jM3Y0QWROWlEyOHUydnNRV0F5VTA3WDZONGM2M0VsSUFETkxpTlVpaG8v?=
 =?utf-8?B?K2FCblNYSFoxWjhScWozNVRucWtXbkdGOXQ1ekxWSTBEYXBhOEVUc250MnlZ?=
 =?utf-8?B?dUNPaWE2TTJ5ZGdhamJaTW16OGhQQmFpazM1NlNpNVRObXdpV01za3FSUkdN?=
 =?utf-8?B?ellTNE1ESGc1eko1NTMvU204NFdSUlEwUmNXNzUzd3hubUZOc1AyeVAwaDY0?=
 =?utf-8?B?R1hzeHdUaWprZjA4YW9UQkpBdkxNWWRLT0ZNekRzSnJuNk9jS2pVclF0cXQ4?=
 =?utf-8?B?VmlrR3pkRm5DbVByNVB3VFZrTkVOUkFLb3c0OW42eXBDYXVYL1JjRkhWK0N4?=
 =?utf-8?B?aHVNWHhuclhUcTc0aEZoTncvMTJYRVAvNXRDcWgyem5lOHhpenliQ0hHUGdZ?=
 =?utf-8?B?TFgwTUdmRmFMUDdYclNTNE5SWVUrcFpCM3U0czV5ck1JZWZpclRBMExKR2lw?=
 =?utf-8?B?MkNwa2tCbVdSOGZOV3lQZTk4Y3JaQk5Ra3pZc2R1UHpQVm1zYldPdklqaHhW?=
 =?utf-8?B?ZFBsZXNOOUpoUU8rRU1GSFNQbSt0MWxWbVF0Z2FPaXVvY3h2bnpkUjRnSkNZ?=
 =?utf-8?Q?T1h6JRhywVaIpkrIRAy2XHds2Io2yKEUscK/snJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2609.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7183502b-6abc-4c8c-8ffe-08d90aa3a7e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 00:13:46.0867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DU2Rdcuuqifon3+Gd99JBTZ6zjDWo0JlXaupAJYXmpa0DwL4VaQ0Mg5tZUURSvlHm/GLUke8wq2WSmiAA7jIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3714
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSYW5keSBEdW5sYXAgPHJkdW5s
YXBAaW5mcmFkZWFkLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDI5LCAyMDIxIDEyOjMw
IEFNDQo+IFRvOiBSZW4sIFFpYW93ZWkgPHFpYW93ZWkucmVuQGludGVsLmNvbT47IGxpbnV4LWJj
YWNoZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IE1hLCBKaWFucGVuZyA8amlhbnBlbmcubWFAaW50
ZWwuY29tPjsgY29seWxpQHN1c2UuZGU7DQo+IHJkdW5sYXBAaW5mcmFkZWFkLm9vbTsgQ29saW4g
SWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtiY2gt
bnZtLXBhZ2VzIHY5IDIvNl0gYmNhY2hlOiBpbml0aWFsaXplIHRoZSBudm0gcGFnZXMgYWxsb2Nh
dG9yDQo+IA0KPiBPbiA0LzI4LzIxIDI6MzkgUE0sIFFpYW93ZWkgUmVuIHdyb3RlOg0KPiA+IEZy
b206IEppYW5wZW5nIE1hIDxqaWFucGVuZy5tYUBpbnRlbC5jb20+DQo+ID4NCj4gPiBUaGlzIHBh
dGNoIGRlZmluZSB0aGUgcHJvdG90eXBlIGRhdGEgc3RydWN0dXJlcyBpbiBtZW1vcnkgYW5kDQo+
ID4gaW5pdGlhbGl6ZXMgdGhlIG52bSBwYWdlcyBhbGxvY2F0b3IuDQo+ID4NCj4gPiBUaGUgbnZt
IGFkZHJlc3Mgc3BhY2Ugd2hpY2ggaXMgbWFuYWdlZCBieSB0aGlzIGFsbG9jYXRpb3IgY2FuIGNv
bnNpc3QNCj4gPiBvZiBtYW55IG52bSBuYW1lc3BhY2VzLCBhbmQgc29tZSBuYW1lc3BhY2VzIGNh
biBjb21wb3NlIGludG8gb25lDQo+IG52bQ0KPiA+IHNldCwgbGlrZSBjYWNoZSBzZXQuIEZvciB0
aGlzIGluaXRpYWwgaW1wbGVtZW50YXRpb24sIG9ubHkgb25lIHNldCBjYW4NCj4gPiBiZSBzdXBw
b3J0ZWQuDQo+ID4NCj4gPiBUaGUgdXNlcnMgb2YgdGhpcyBudm0gcGFnZXMgYWxsb2NhdG9yIG5l
ZWQgdG8gY2FsbA0KPiA+IHJlZ2lzZXRlcl9uYW1lc3BhY2UoKSB0byByZWdpc3RlciB0aGUgbnZk
aW1tIGRldmljZSAobGlrZSAvZGV2L3BtZW1YKQ0KPiA+IGludG8gdGhpcyBhbGxvY2F0b3IgYXMg
dGhlIGluc3RhbmNlIG9mIHN0cnVjdCBudm1fbmFtZXNwYWNlLg0KPiA+DQo+ID4gdjk6DQo+ID4g
ICAtRml4IEtjb25maWcgZGVwZW5kYW5jZSBlcnJvcihSZXBvcnRlZC1ieSBSYW5keSkNCj4gPiAg
IC1GaXggYW4gdW5pbml0aWFsaXplZCByZXR1cm4gdmFsdWUoQ29saW4pDQo+ID4NCj4gPiBSZXBv
cnRlZC1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+ID4gU2lnbmVk
LW9mZi1ieTogSmlhbnBlbmcgTWEgPGppYW5wZW5nLm1hQGludGVsLmNvbT4NCj4gPiBDby1kZXZl
bG9wZWQtYnk6IFFpYW93ZWkgUmVuIDxxaWFvd2VpLnJlbkBpbnRlbC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogUWlhb3dlaSBSZW4gPHFpYW93ZWkucmVuQGludGVsLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDb2xp
biBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2
ZXJzL21kL2JjYWNoZS9LY29uZmlnICAgICB8ICAgOCArDQo+ID4gIGRyaXZlcnMvbWQvYmNhY2hl
L01ha2VmaWxlICAgIHwgICAyICstDQo+ID4gIGRyaXZlcnMvbWQvYmNhY2hlL252bS1wYWdlcy5j
IHwgMjg1DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2
ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuaCB8ICA3NCArKysrKysrKysNCj4gPiAgZHJpdmVycy9t
ZC9iY2FjaGUvc3VwZXIuYyAgICAgfCAgIDMgKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDM3MSBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPiBkcml2
ZXJzL21kL2JjYWNoZS9udm0tcGFnZXMuYyAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ID4gZHJpdmVy
cy9tZC9iY2FjaGUvbnZtLXBhZ2VzLmgNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2JjYWNoZS9LY29uZmlnIGIvZHJpdmVycy9tZC9iY2FjaGUvS2NvbmZpZw0KPiA+IGluZGV4IGQx
Y2E0ZDA1OWMyMC4uMzA1N2RhNGNmOGZmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbWQvYmNh
Y2hlL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL21kL2JjYWNoZS9LY29uZmlnDQo+ID4gQEAg
LTM1LDMgKzM1LDExIEBAIGNvbmZpZyBCQ0FDSEVfQVNZTkNfUkVHSVNUUkFUSU9ODQo+ID4gIAlk
ZXZpY2UgcGF0aCBpbnRvIHRoaXMgZmlsZSB3aWxsIHJldHVybnMgaW1tZWRpYXRlbHkgYW5kIHRo
ZSByZWFsDQo+ID4gIAlyZWdpc3RyYXRpb24gd29yayBpcyBoYW5kbGVkIGluIGtlcm5lbCB3b3Jr
IHF1ZXVlIGluIGFzeW5jaHJvbm91cw0KPiA+ICAJd2F5Lg0KPiA+ICsNCj4gPiArY29uZmlnIEJD
QUNIRV9OVk1fUEFHRVMNCj4gPiArCWJvb2wgIk5WRElNTSBzdXBwb3J0IGZvciBiY2FjaGUgKEVY
UEVSSU1FTlRBTCkiDQo+ID4gKwlkZXBlbmRzIG9uIEJDQUNIRQ0KPiA+ICsJZGVwZW5kcyBvbiBM
SUJOVkRJTU0NCj4gPiArCWRlcGVuZHMgb24gREFYDQo+ID4gKwloZWxwDQo+ID4gKwludm0gcGFn
ZXMgYWxsb2NhdG9yIGZvciBiY2FjaGUuDQo+IA0KPiBQbGVhc2UgZm9sbG93IGNvZGluZy1zdHls
ZSBmb3IgS2NvbmZpZyBmaWxlczoNCj4gDQo+IChmcm9tIERvY3VtZW50YXRpb24vcHJvY2Vzcy9j
b2Rpbmctc3R5bGUucnN0LCBzZWN0aW9uIDEwKToNCj4gDQo+IEZvciBhbGwgb2YgdGhlIEtjb25m
aWcqIGNvbmZpZ3VyYXRpb24gZmlsZXMgdGhyb3VnaG91dCB0aGUgc291cmNlIHRyZWUsIHRoZQ0K
PiBpbmRlbnRhdGlvbiBpcyBzb21ld2hhdCBkaWZmZXJlbnQuICBMaW5lcyB1bmRlciBhIGBgY29u
ZmlnYGAgZGVmaW5pdGlvbiBhcmUNCj4gaW5kZW50ZWQgd2l0aCBvbmUgdGFiLCB3aGlsZSBoZWxw
IHRleHQgaXMgaW5kZW50ZWQgYW4gYWRkaXRpb25hbCB0d28gc3BhY2VzLg0KPiANCj4gDQo+IEFs
c28sIHRoYXQgaGVscCB0ZXh0IGNvdWxkIGJlIGJldHRlci4NCg0KSGkgUmFuZHk6DQogICAgIFRo
YW5rcyB2ZXJ5IG11Y2ghIEknbGwgY2hhbmdlIGluIG5leHQgcGF0Y2ggc2V0Lg0KDQpUaGFua3Mh
DQpKaWFucGVuZw0KPiAtLQ0KPiB+UmFuZHkNCg0K
