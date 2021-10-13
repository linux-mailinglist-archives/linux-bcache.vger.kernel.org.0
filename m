Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C367B42B956
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 09:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbhJMHlW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 03:41:22 -0400
Received: from mail-eopbgr1300125.outbound.protection.outlook.com ([40.107.130.125]:29568
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232147AbhJMHlW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 03:41:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQltbZcxd/9bYk4fqTblh/7tpcYQVTohcm87vNNF1NxELMWG7APjga7GnQj6a4hUQpDpSHvYAMsCrLZaayOoRxVqDX0kUDaEj1U5Wd3eSTP+AvVdmcvRRFK566L8yn6gPETzgol5nXO+EtolQPdRBl5jIlr1s2mjoCUmkWOPprORgvIEQIBM3j7iosgW5DLoplLKYnQL2mlKb5Ws8bHMpFbA/x7LwcvrOZhqCBCaFt92bXZ7VZtNxhImIi88np7oP2ZbD7jCHGFuifiZgM+rfgExMF6btfMV3Nbr6uPZrLNlIjqsB0Mrhf6HrZuT0XqNBRp883i4mxGgg3tFAslovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2p2n8CYaecWX6f9RfZFdJj3jIlxrJMH+wDduqvaMMk=;
 b=m3Xcn88N0Ayi8aX8ah3rEi1f7nPkzp2DGB8YHEu15HPjLeJmn2ZQwbXaJwWe1WB+GRDc5TJS64P7R+z/+rO2xtr4i6BC2OxKGwpUaRlmJf6OFY4xG2vIjT+zTTzvXYqyS2G9vk5ffAWcVxj9oF595rgZSEveCYLYfwzgwEaumIq1Fi0nwBBWgtCBPqHzjg0CCPLjeZ2aXY3LB6IrQOrT8kAMfAV2uitA0PTYduBFYI2oVdl5TEcItPJamNBG9llKV5aP0Uo29IavxO5Qmlskzxl9zEiJvZvoSjrfKxAtSXpMtpWxNS/AETPuiTFXH+d6BpIuZb3pWhUq3VT6qhRlqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2p2n8CYaecWX6f9RfZFdJj3jIlxrJMH+wDduqvaMMk=;
 b=YfmIYaQ06yAOM5NETuV32bfctP9x1LLC0qE7IcPpOxR/WTyvpZEom3yuachVAJTvjNG7A4x8eBk15mE2r+W+h48cEGqyfcbOBYCbS4XcOAuoqHmLfvOy5x57Io0PrsrbSwbuOn6KfitFPGWS6cHwnPhr/BCdmd76iWlRD9edX/8=
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3132.apcprd06.prod.outlook.com (2603:1096:100:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 07:39:15 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 07:39:15 +0000
From:   =?utf-8?B?546L5pOO?= <wangqing@vivo.com>
To:     Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?5Zue5aSNOiBbUEFUQ0hdIGJjYWNoZTogcmVwbGFjZSBzbnByaW50ZiBpbiBz?=
 =?utf-8?Q?how_functions_with_sysfs=5Femit?=
Thread-Topic: [PATCH] bcache: replace snprintf in show functions with
 sysfs_emit
Thread-Index: AQHXv+I+XCTo8mKdYU+ID5FPw+18aKvQf9+AgAAI6nQ=
Date:   Wed, 13 Oct 2021 07:39:15 +0000
Message-ID: <SL2PR06MB3082B818199080975B93D0B6BDB79@SL2PR06MB3082.apcprd06.prod.outlook.com>
References: <1634095639-4227-1-git-send-email-wangqing@vivo.com>
 <AI*ALgD1Em5Q2PfGyVlLhqrx.9.1634108359294.Hmail.wangqing@vivo.com>
In-Reply-To: <AI*ALgD1Em5Q2PfGyVlLhqrx.9.1634108359294.Hmail.wangqing@vivo.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 8141a358-531c-4cb3-e526-1a38ea5a6423
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c5c4461-726d-4531-d682-08d98e1c8ef4
x-ms-traffictypediagnostic: SL2PR06MB3132:
x-microsoft-antispam-prvs: <SL2PR06MB31329E6D8FAA2FEC6027F90DBDB79@SL2PR06MB3132.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgO9HroIkyRpSpxr98NXp+FTeHIo0ugbY+dbJjTclvUO54NDfEy7q7naEc2ePpTBBCg3/KIV0geauncJ2RsFomhn8NZTN1/bvsagP64vbSDn5H6fs2zpfT6aCE1vRhROLeAXfA1QyxD/nzQOZ7/+VKauAKSp8w5JsP5yhwynUhnhy+JzFmP3jJveay8Ogxi0aDHSxCvZJ/evlwDsfnIcDMsLudDHe6lD2ORCMePirHG4XTp9bhMtnRkPxvPW7gNpZPq1ksnoGK9CynAyFzwTayhZxNuq3/08ukY8j2l7GdxmdRSmlvTFOUCqqPyjzFGltqihWpD7/kc+4HGKadCqQMKKhKPAtjWtTq5MpIAkh+xjd+r/YShZJd9ZXKdctxh4iaxo9JiWzxT0+a5RNKsKYtk9/xJgsOyk1DNBbvjlcK4bfyHFKjgcdDa41nAMpEFQ3V2mDdEjqHA8voJQOKaMqjX4KNkkUERGErESOEgXZAASWIBnS7krnN7pMoFuCCeXUxZcIp63y0srVGtTwPIAK0wFZAq74078AB7R2DbpatVvSwoXdR8Sf1GoolzR4bpvr6qu6MsUbX8N7lVfQS+gfjxZ2ghDuc6bkrP5bmKl/ffIlZg9fV+FfTM2gPymE0dFAQSRDqiNhIzm8WzeTC32cI1h+eJd9k0nYPD+504zWl4z1tstjlc6h5DoScD/XlWD3hbjtTmXmoS4RcB0Wjls8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(5660300002)(91956017)(66556008)(76116006)(6916009)(64756008)(66446008)(66476007)(66946007)(52536014)(86362001)(316002)(4744005)(508600001)(9686003)(33656002)(2906002)(4326008)(6506007)(54906003)(224303003)(55016002)(186003)(85182001)(83380400001)(7696005)(38070700005)(8936002)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjNTTnJ0Sk14akZ6ajNEVzVUdkJhZG1MV3lhWUM2dktjZk43UG1zSS9GRFNY?=
 =?utf-8?B?eWtTRUp6dWZZV0k3ZVJTcFkyMTZPRkZSSUlnRWhxeDQyQlZGd0F5THBGUHpa?=
 =?utf-8?B?R2Z5UnRJT3A0VzJoUkNCSEtCdDdUL1ZSNnVnVzRBQlg3R3R5UHV6WDZzeWVK?=
 =?utf-8?B?NXdvS0hKbkFuUytYM2RyOFBrNmtrekozUTJWQkFMaU9oZUFoT1dtVlBhNm5U?=
 =?utf-8?B?M0RqUWVqbzYvVUR5REU0bVpzY1V4STFHY2JYWWRRYStJUU5DVHNDdlRpTThm?=
 =?utf-8?B?QVFxSWpmYkhxKytNbWFnSVhUZXpGNkwyaXhaQ0ErampTV2VqSWRRMXZ4ZitU?=
 =?utf-8?B?a0tyUUJxd3hQRkkyeXV3Y1A1aEJlNXpRdmxTaFpQQThLWk1jSisxMWxLZjN6?=
 =?utf-8?B?dTJJclkvT2x1QzBXZmFRUmJrR3AxWGtQT0ZlSW5RRld4Q1BsbFBEMkhqUGgy?=
 =?utf-8?B?ayswOHhxYUZKVlBIQi8zUmd2OE4wY3QrUjRmdlpaT1llOUxaS0hYTW5vYnhG?=
 =?utf-8?B?ZSt5YXFnWnJUZnk4MlBGYVF6dkd3Q1ZPcFZEa1pmcEwzY2orVWk3enZ6OHlp?=
 =?utf-8?B?RHlkbEtwL2xqRmRVbzgxQ2FVOWlPdmFpS0Jjc294QlA4UWJad2hIcnNxb2ll?=
 =?utf-8?B?UzFTK3hxaS9lV0RINzljT2NnR0h4NCtydnpjYVArai9iU2RMZCtONEMrcnMv?=
 =?utf-8?B?bHlwS21FQ2pzTVpqTCt6WTdhTktwQU5WMnJZZVkzMmtUODVrTFFOY1gyVjIx?=
 =?utf-8?B?ZzJrZzFvb0owWFpIbkI3RWlXVk5FejdPYkRQMngycWRPSHU0UUEzSlpuMHVm?=
 =?utf-8?B?Y3hXMmNiYVZqRHNDcmJ6VTRjYzFhd1hpZEhKT2pvTFE3Q1ZqNmYvRWtMZmJv?=
 =?utf-8?B?cUp1Z2RXZVVkbGRnaHZOcmdyekxXa0FaYzZPVWJBcjc2VWFrK3RjSHUyYXpm?=
 =?utf-8?B?UStOeDFZZ2F2MVdCU2JvWmgxa1BSaUllRjZEdUZLazRpcjJoWDk4b1ZvbUM3?=
 =?utf-8?B?b015MUdCZXQyYnRzdDI1MzdCVG9pbHhqN0xwYzg1U0FCQk0xSVpLUm9LUC94?=
 =?utf-8?B?Q0RoQlR6aGVLeTBoOUV6UWlreE5yQU1DemJXVzNQTDNMcTBGNVZ2SFZBZncz?=
 =?utf-8?B?Z2NwVmphczVaTHIzNTVPTkF3NjZZVzV0M3N2c3NsZzM0S0I4UXRyY1pEcnRY?=
 =?utf-8?B?T21EVHMrZnpWUWNSSWNad0R5TGpLYzlxU2VjYVZ0TUN2WUhFUU9DalBVS0Ns?=
 =?utf-8?B?U2NNTC9IbTlJa09wOXUyQ2FrWHRsZHBvYVNqOEFCdnVkd205Mmk3TXFBeXBP?=
 =?utf-8?B?NDlTUGFDQjVZZDBhWGJDZ3lsZUU5K09MRGVwL3lwc2NlWlNlVzJEVFdsT3dY?=
 =?utf-8?B?M0Q1aXozSjVCejNSUS9CbVJtaTJNLzBtYlI4eE5VdldyT3RXY3A4Nkx3ZWdC?=
 =?utf-8?B?VnhMY0N1MHMrSWhBdGp6WURzZ0Fib2hUNFJ3UkYrRnJ3WXc1Ujg0bjcwNnhS?=
 =?utf-8?B?ekh1U3FweUd4THRsYmRFeHVsNW1ZWGdSeFYyQy9mWlFiMmR1alhyYVpqVHli?=
 =?utf-8?B?MCtIRld1TFl0Mm9JNnBmS0RaeHpNM3Jsb3VPckpXbHljTVpIdDJGMnB6aUlw?=
 =?utf-8?B?Q2sweEh5MGREcEVvNGcvMGRqTmtMTXRNOGFYdTN5U20yK2tpdlJlZ0MwZ2ZW?=
 =?utf-8?B?VllCY3VWamxrRUJ3NlhTWDZSU3NBTkdNTzY2TkxXeGFjTklWeW81RGZuS3I3?=
 =?utf-8?Q?0BP5cTgQFXkrzRTFoxqfzKSBMKVrXUzEwUkn7pa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5c4461-726d-4531-d682-08d98e1c8ef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 07:39:15.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gNOYHsIXGnuhwZuBKCpaLaFHac5rR9SXJ9P05/J0oc7FMzMFnifJHOFv6mPqIh8Hkts3Gd/JhmMBG5WKtRuxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3132
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Cj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5oIGIvZHJpdmVycy9t
ZC9iY2FjaGUvc3lzZnMuaAo+PiBpbmRleCAyMTVkZjMyLi44YmVjMzJkIDEwMDY0NAo+PiAtLS0g
YS9kcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5oCj4+ICsrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N5
c2ZzLmgKPj4gQEAgLTUxLDcgKzUxLDcgQEAgU1RPUkUoZm4pwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+PsKgwqAgI2RlZmluZSBz
eXNmc19wcmludGYoZmlsZSwgZm10LCAuLi4pwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwKPj7CoMKg
IGRvIHvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwKPj7CoMKgwqDCoMKgwqDCoCBpZiAo
YXR0ciA9PSAmc3lzZnNfICMjIGZpbGUpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCBmbXQgIlxuIiwgX19W
QV9BUkdTX18pOyBcCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHN5c2ZzX2Vt
aXQoYnVmLCBmbXQgIlxuIiwgX19WQV9BUkdTX18pO8KgIFwKPj7CoMKgIH0gd2hpbGUgKDApCj4+
wqDCoCAKPj7CoMKgICNkZWZpbmUgc3lzZnNfcHJpbnQoZmlsZSwgdmFyKcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gCj4gSU1ITyBJIGxpa2UgdGhpcyBjaGFuZ2UgOi0pIEJU
VywgZm9yIHNucHJpbnQoKSBmcm9tIHV0aWwuaCwgaXQgc2VlbXMgCj4gb25seSB0byBiZSB1c2Vk
IGJ5IHN5c2ZzX3ByaW50KCkgaW4gc3lmcy5oLCB3b3VsZCB5b3UgbGlrZSB0byBjaGFuZ2UgaXQg
Cj4gdG8gdXNlIHN5c2ZzX2VtaXQgdG9vID8KPiAKPiBUaGFua3MgZm9yIHRoZSBwYXRjaC4KPiAK
PiBDb2x5IExpCj4gCgpzeXNmc19wcmludCgpIHNob3VsZCBhbHNvIGJlIG1vZGlmaWVkIGlmIHNp
emUgaXMgYSBmaXhlZCB2YWx1ZSBQQUdFX1NJWkUsIApidXQgaGVyZSBpcyBwYXJhbSwgaXQgd291
bGQgYmUgYXBwcmVjaWF0ZSBpZiB5b3UgaGF2ZSBiZXR0ZXIgbWV0aG9kLgoKVGhhbmtzLAoKUWlu
Zw==
