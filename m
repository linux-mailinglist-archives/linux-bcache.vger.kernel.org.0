Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCAB701A9A
	for <lists+linux-bcache@lfdr.de>; Sun, 14 May 2023 00:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjEMWv2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 May 2023 18:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEMWv1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 May 2023 18:51:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733DE2684
        for <linux-bcache@vger.kernel.org>; Sat, 13 May 2023 15:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoWIWvGHn8PNjQTFeGIRmWiegWZmgvSZOnr969sOPHrK+vAoJNUOdVskZ+rfRMKbgSgwb0W6BAo70YleR2jqejZAR2D96kz5VaCohpzhExtkykjyXmey8Qx1X5h2kQbXZzEAndFnCF+6EwgF5HV67OCgEXIGvSjcvnJiS/1t/VcVv1g2xcbNW1mP62gFCPxhSQqLg8nH9xGV18LmCZ+fy7zMbzXuJetPVBJPla0bypuCWsbrRf7IB8uHMFUpFjgWy6Jy3E7IPZ1RaftgAlbv5Um1rjUwrSkXfFFOcV/F5V0l+GSwekRfN3ZyGcJHkp6rmZJII+UKZWLEYssYbdEoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO1Y2Knmbg2PwdTrtYnEwRmvbBFBHHJmMSjE7DVLhzk=;
 b=QNplPPFmWDetWm+dZOTOEEX3VdkIvQYf+6B4zlNEf4I1S/ECa/DT7G2f3WB26SKDV28QN7Wrbswy95Ef2ljHOLUVQgHtnI6uThQyvI9PKW1UTRf4mbLhfVrmUHpuOZDkUgHkaE7SXu/qjw5FDfRZdZwH3qe26pTjF/mL/F3Y/t7xm37R1eWxsCgPwuyarLJcfFdAQZ4FimN7qD0M0/6rLksGTDuoLuAGPL0F4Gaxj92PJk8YVpt6G5zU/ag6nbG7d28oAoAU7JnkM8JrAktBLFH3kuQF6K8exAkg5OcJLxWXhkQ/0T4PMhpZStUU3hvFohNwH7Fn/NOeT7NKhrjAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO1Y2Knmbg2PwdTrtYnEwRmvbBFBHHJmMSjE7DVLhzk=;
 b=WVVWJKGMmN6g0B74ICrrfQYLVxF4kyz/WQLds/tc9WvG85U4Zd86/oiK7MgpnvUZHw4Kb2lVVv8sz4H1r45z9bk8KX//Ds8/B32zTxLmJmrcuBjvnPKCVx7r3597zKxUjSVbhCwNgCVAgjaOpUfqjd53m3QR30rn7KPHDpQ0AYN8TMQwNupPxSDhOvHnh3x7ktzgTz23FxJLOCDOWO8yY2asYn60LUkPwUFeLKJonWJtEsw7/lIfBTkYjOoid2ct1dZVwdmm8GX+3jUtz4ojawrY0vWTHUOe99tlEX5UNDJHzHTxcBioQHj+VsRichW0ABTsL3D0fFO6udX3bBsb2w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS7PR12MB8290.namprd12.prod.outlook.com (2603:10b6:8:d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.28; Sat, 13 May
 2023 22:51:21 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 22:51:21 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH 1/1] bcache: allow user to set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH 1/1] bcache: allow user to set QUEUE_FLAG_NOWAIT
Thread-Index: AQHZhLfLVp7oO3Wwd0KaABhQ7Uj4q69YurqAgAAWtAA=
Date:   Sat, 13 May 2023 22:51:21 +0000
Message-ID: <abd5b7bc-2b39-af7c-9593-dcb1a7af879a@nvidia.com>
References: <20230512095420.12578-1-kch@nvidia.com>
 <20230512095420.12578-2-kch@nvidia.com>
 <31bfee17-47f0-b1ca-eb0-baf0762b41e8@ewheeler.net>
In-Reply-To: <31bfee17-47f0-b1ca-eb0-baf0762b41e8@ewheeler.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS7PR12MB8290:EE_
x-ms-office365-filtering-correlation-id: ad15cf9a-7b55-444d-cfad-08db54049235
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9v4Ay/Eb8B6TEyDvoDfMjZRzj3l7fofPMqgF2khtaQqRuwPA7FfdLVWPJ2Q9VpDtnFFRJfl3REnNmM72B47VbCPke5z3yzLxeCJ51K6+8I47xsQDf/2s4606ItvgVaVU2ay3SfYePzWDsLkNfJL4dnDSxP9ymxu5uMKKUTqwZH4dGo2k8HKxgLZTYnAA38LDdHC1JEaxCOBpSy8wv9FT1La0ZOHYBiq8SkYd3nJdnJDi4WiMnqrCT6o9k6f+7FQAsWOd5XtNGkntvIPDu2Myo5Jec6eE1u39hnbMh6eJzGGrw6U0sojsDAmUFQ0e+KVbCLicnmT3BsI3QAl9pzeWjY90yrmOmf9+iH2axj9m7KZQqlaOsJ7ZaCP0ZL/e47S0qs22OnbmKjGdA38qVaa3eTRbAhRIrZ+Rs8VfM21NfJmlC/m0UL/VO6UY0+Tz0EQUzEpH7oHPjXNWn/BTQdUUu9TpUSsVdHfnnA/Dr6ftAQEuWtza+Sya4fT64+85jGJoeIgc0KN4F8xkooT5cJdk2mQnCfbwctO3wr2NiEf2AJYJOw0N+u8cjefWdSK1/86Gb1FiWleYQlMbAldOS/SOc5v19jGhnQUhGsheoYQnGGe/IC7G89elbchnHrhVeszeYWDYM+ScGAtDMgisErldL+TSRp1R7Nj6/JDuPnSdnjlx0ZsApNUF1UmdfrqRFPVQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(38100700002)(122000001)(31696002)(83380400001)(38070700005)(2616005)(53546011)(186003)(71200400001)(36756003)(6486002)(54906003)(110136005)(478600001)(6506007)(6512007)(4326008)(91956017)(316002)(66556008)(66946007)(76116006)(66446008)(66476007)(64756008)(31686004)(86362001)(41300700001)(5660300002)(8936002)(8676002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGo5dFcyd1VpcHdwSEl4VHpBMlRLZm9SWXJya1lRbkdwelFPMWNMTFdDWW45?=
 =?utf-8?B?T1NtMmZhanVBTDA3U0ZBMC9OeC9wQlBQYjRwdmwxOUJjYlVrUHZiNDF0T3o5?=
 =?utf-8?B?RUNCQXNFYWxrQkJOY1J1a2lrTngzclV3QlNmVjcxVllJNmF6L0xoK04rUXgz?=
 =?utf-8?B?RnZHdTRVZkJ0N3BVbm1FTDJlV0dsUU54eDJ6clFkK0tTajFzK1ZzS2duT3Zz?=
 =?utf-8?B?YVVYeFdtTHhWTTM1endnZVUrRGdvbDJpdDNmd1d5amhOMk5lNnAybmRUeVBm?=
 =?utf-8?B?RzNLS0hiRVlxSlA0eEVOV1FSTGJyV245TWQ4b2VGVU5IdmplcnBIS0oyWTZp?=
 =?utf-8?B?Ump2WFpDNEozbHJYWDE1WU5VZFREeFhLUnF1MlV5WUc2blVncG1Ibi9NMDBZ?=
 =?utf-8?B?Z01yKzRTbzZDZXRQNExmRHZKc0lVYThzbnJpMEhoR2s0U1B2bllYVGx0Qnkx?=
 =?utf-8?B?Sm81TE5iRzZBdTNpVjRGd2pVejBBTjRUc2VsMm1rQjY2WFU0Z2drWHQrUFJ3?=
 =?utf-8?B?VSt5MUJMS0xGZzJjSTJqbkJyQWxMU2lzQTZWd3hsWldtemtrTUd3ZWFlMytp?=
 =?utf-8?B?djk4VEdZV3NkMDRNR0hNS2hXanREMElUMWFab1F4YUplN1RydXlyRFhkeURj?=
 =?utf-8?B?WjNXQ2dEVUs0bkRzd2hJQVdZV2NiSzZUaUYvbThVYzBPWCtCVGdVeXVFN0Z3?=
 =?utf-8?B?aXBEN0dYMGFsL3RlbS9jTUp3YTRsRHphbGpUOVd0L3RscjE0UjZLWUFEREQr?=
 =?utf-8?B?N1IxK2dRMitQU3B3cms2N01aOE50bUFSaldRcUt4bytKckU1WUlPM1k1eUhJ?=
 =?utf-8?B?OWQ5dFlHdkh3NUxuVFEvajhEZWJiZ2JGUzQ0eHg1TkJsZWs2dzJGMEh6dkg2?=
 =?utf-8?B?MTVrUXlXVXhpMWh3cFBSRUZZZ0dyY2JSYXptRDVkOVk0TTJ2NmJzRFdFVU9P?=
 =?utf-8?B?STRBNjNoS1ljQlFVKzlCZjh1T2tKU2tUVW50b1pxNHBIWXhXeUs1RUJSbFRR?=
 =?utf-8?B?dXFmTThJSDZXTE4yQ1RnKytWNXhUdUxYdVdnemo3ZTJUbG51V1c3Yk10b0ZL?=
 =?utf-8?B?dTRqU2IvWi9EU1FjN2lCeWUyUG1WTWxwMkxiYWFCdEN5ZUcxL2I2aWhyRlNj?=
 =?utf-8?B?YU5xTGNTVnBvTExJQzZMYUxlU3VBOHJnNGE2a1VJYStWZlg1OVhhV09DT0No?=
 =?utf-8?B?aHBTVTlPd2ZtR3crTnZDTFMxaEFvbS9pRVl1M1Z4cmhoUDFXbUtDcjlDODJB?=
 =?utf-8?B?eXN2b2duaGR2SUp0aW5rRW82OTU4alNPbWZjd2VoZDJ5TnBhdW9wcEdYYStD?=
 =?utf-8?B?bkxkeG9kRE5nWFFDWDJ2aFZzWWlaV1BVMlA0ZXlLbmxUbUpvT1FHelFtdk40?=
 =?utf-8?B?ZW01dW9ubndyekM2NVBNVVcrbkFRNkdDYXl2cEhGQWFNRGNHOHAzV1NuU1FK?=
 =?utf-8?B?OGw1Z25BYnVJYzlCSU51NU5zaERESGh4VzBDekFzZUphNTFOK25pVDh6emVL?=
 =?utf-8?B?MEt0Tm54aWFoOHB5MWZqZkIyc3dSamFNNDl3V0tXbk1MUHhqMU5Yb2NiMnkr?=
 =?utf-8?B?R0d6bjBYUForV0pKSWRZdTg5RVUwSVloK3RDTnk2dnRURm1NUEw1Ym5oaEhB?=
 =?utf-8?B?K2hodndFWk00U2kyejBBYnJGVmdnTERhdFpuUDV4YjVCMVF3aFRpbDU4RFJH?=
 =?utf-8?B?L2FPWjE4WTVvNDhCNEpRaVcxRlN2QVJFZEh6d1ZDb0hIeEwwSFZSai9YamVX?=
 =?utf-8?B?WXRiNEpDTG0rV292dnVERi8wbHE2VVpGZmQwdUtUUGlQTkREMXlIVlVSUUdk?=
 =?utf-8?B?WkRKS0JnS0J3cDFLaXZvczhzUFY5M0N2NFMrSWlOeE5KUmYrc050aHQ3c2Qr?=
 =?utf-8?B?OThwWGcwSWJDNXBhN1JHQ3RuMzY4V28rYzhzdWlzNy9LVkZOYW5Sd0w5Si8x?=
 =?utf-8?B?ajFUUmpVeTNxMm1hVkZVWnJqWHFtS0dKdGF3WEhXSnZPYlhuV1o5Mm5qZEFN?=
 =?utf-8?B?ZGVnZ2xNVVdoVkpJT1E1a1VYanNDY0M5SkJjdkRKUEROS01meElRM2Izc2pv?=
 =?utf-8?B?WCtFUHVuSUtFOWt6VlNicjRSQUEvOCtwSWxKRzBlWGFka1RHaFlOSVNzVVJD?=
 =?utf-8?B?NHd2eDBhL0E3U3hvblhQVWY1bDNzV1JrU1NHVjErMDAvbEM4Y2VWTURUbGJD?=
 =?utf-8?Q?kjYFOXHHpbsj06ZwLyJiNeQjNUOQn3UmZf1IA4gvhFxK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19B23E37BF47CD49B7B35DD0222377C5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad15cf9a-7b55-444d-cfad-08db54049235
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 22:51:21.2235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oxft/LTo2sWSDtBpLvra9KA15CLZF0MrNGpVgHzdv15OK1wrS+F1KHJ+KJRkvmhwxRIKJ/AEHSwtuJwsOWPtcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8290
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gNS8xMy8yMyAxNDozMCwgRXJpYyBXaGVlbGVyIHdyb3RlOg0KPiBPbiBGcmksIDEyIE1heSAy
MDIzLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6DQo+DQo+PiBBbGxvdyB1c2VyIHRvIHNldCB0
aGUgUVVFVUVfRkxBR19OT1dBSVQgb3B0aW9uYWxseSB1c2luZyBtb2R1bGUNCj4+IHBhcmFtZXRl
ciB0byByZXRhaW4gdGhlIGRlZmF1bHQgYmVoYXZpb3VyLiBBbHNvLCB1cGRhdGUgcmVzcGVjdGl2
ZQ0KPj4gYWxsb2NhdGlvbiBmbGFncyBpbiB0aGUgd3JpdGUgcGF0aC4gRm9sbG93aW5nIGFyZSB0
aGUgcGVyZm9ybWFuY2UNCj4+IG51bWJlcnMgd2l0aCBpb191cmluZyBmaW8gZW5naW5lIGZvciBy
YW5kb20gcmVhZCwgbm90ZSB0aGF0IGRldmljZSBoYXMNCj4+IGJlZW4gcG9wdWxhdGVkIGZ1bGx5
IHdpdGggcmFuZHdyaXRlIHdvcmtsb2FkIGJlZm9yZSB0YWtpbmcgdGhlc2UNCj4+IG51bWJlcnMg
Oi0NCj4+DQo+PiAqIGxpbnV4LWJsb2NrIChmb3ItbmV4dCkgIyBncmVwIElPUFMgIGJjLSpmaW8g
fCBjb2x1bW4gLXQNCj4+DQo+PiBub3dhaXQtb2ZmLTEuZmlvOiAgcmVhZDogIElPUFM9NDgyaywg
IEJXPTE4ODVNaUIvcw0KPj4gbm93YWl0LW9mZi0yLmZpbzogIHJlYWQ6ICBJT1BTPTQ4NGssICBC
Vz0xODg5TWlCL3MNCj4+IG5vd2FpdC1vZmYtMy5maW86ICByZWFkOiAgSU9QUz00ODNrLCAgQlc9
MTg4Nk1pQi9zDQo+Pg0KPj4gbm93YWl0LW9uLTEuZmlvOiAgIHJlYWQ6ICBJT1BTPTU0NGssICBC
Vz0yMTI1TWlCL3MNCj4+IG5vd2FpdC1vbi0yLmZpbzogICByZWFkOiAgSU9QUz01NDdrLCAgQlc9
MjEzN01pQi9zDQo+PiBub3dhaXQtb24tMy5maW86ICAgcmVhZDogIElPUFM9NTQ2aywgIEJXPTIx
MzJNaUIvcw0KPj4NCj4+ICogbGludXgtYmxvY2sgKGZvci1uZXh0KSAjIGdyZXAgc2xhdCAgYmMt
KmZpbyB8IGNvbHVtbiAtdA0KPj4NCj4+IG5vd2FpdC1vZmYtMS5maW86IHNsYXQgKG5zZWMpOiAg
bWluPTQzMCwgbWF4PTU0ODguNWssIGF2Zz0yNzk3LjUyDQo+PiBub3dhaXQtb2ZmLTIuZmlvOiBz
bGF0IChuc2VjKTogIG1pbj00MzEsIG1heD04MjUyLjRrLCBhdmc9MjgwNS4zMw0KPj4gbm93YWl0
LW9mZi0zLmZpbzogc2xhdCAobnNlYyk6ICBtaW49NDMxLCBtYXg9Njg0Ni42aywgYXZnPTI4MTQu
NTcNCj4+DQo+PiBub3dhaXQtb24tMS5maW86ICBzbGF0ICh1c2VjKTogIG1pbj0yLCAgIG1heD0z
OTA4NiwgICBhdmc9ODcuNDgNCj4+IG5vd2FpdC1vbi0yLmZpbzogIHNsYXQgKHVzZWMpOiAgbWlu
PTMsICAgbWF4PTM5NTE5LCAgIGF2Zz04Ni45OA0KPj4gbm93YWl0LW9uLTMuZmlvOiAgc2xhdCAo
dXNlYyk6ICBtaW49MywgICBtYXg9Mzg4ODAsICAgYXZnPTg3LjE3DQo+Pg0KPj4gKiBsaW51eC1i
bG9jayAoZm9yLW5leHQpICMgZ3JlcCBjcHUgIGJjLSpmaW8gfCBjb2x1bW4gLXQNCj4+DQo+PiBu
b3dhaXQtb2ZmLTEuZmlvOiAgY3B1ICA6ICB1c3I9Mi43NyUsICBzeXM9Ni41NyUsICAgY3R4PTIy
MDE1NTI2DQo+PiBub3dhaXQtb2ZmLTIuZmlvOiAgY3B1ICA6ICB1c3I9Mi43NSUsICBzeXM9Ni41
OSUsICAgY3R4PTIyMDAzNzAwDQo+PiBub3dhaXQtb2ZmLTMuZmlvOiAgY3B1ICA6ICB1c3I9Mi44
MSUsICBzeXM9Ni41NyUsICAgY3R4PTIxOTM4MzA5DQo+Pg0KPj4gbm93YWl0LW9uLTEuZmlvOiAg
IGNwdSAgOiAgdXNyPTEuMDglLCAgc3lzPTc4LjM5JSwgIGN0eD0yNzQ0MDkyDQo+PiBub3dhaXQt
b24tMi5maW86ICAgY3B1ICA6ICB1c3I9MS4xMCUsICBzeXM9NzkuNzYlLCAgY3R4PTI1Mzc0NjYN
Cj4+IG5vd2FpdC1vbi0zLmZpbzogICBjcHUgIDogIHVzcj0xLjEwJSwgIHN5cz03OS44OCUsICBj
dHg9MjUyODA5Mg0KPg0KPiBXb3csIGFtYXppbmcgZm9yIHN1Y2ggYSB0aW55IHBhdGNoLiAgRXNw
ZWNpYWxseSB0aGUgbGF0ZW5jeSBudW1iZXJzISBHaXZlbg0KPiB0aGlzLCBtYXliZSBOT1dBSVQg
c2hvdWxkIGJlIGVuYWJsZWQgYnkgZGVmYXVsdC4NCg0KeWVzLCBzZW5kaW5nIG91dCBWMiB3aXRo
b3V0IHRoZSBtb2R1bGUgcGFyYW1ldGVyIGFzIG15IG90aGVyIHBhdGNoZXMNCmhhcyBzaW1pbGFy
IGNvbW1lbnQgdG8gZW5hYmxlIG5vd2FpdCBieSBkZWZhdWx0Lg0KDQo+IFdoeSB3b3VsZCBhbnlv
bmUgd2FudCB0byB1c2UgdGhlIG9sZCBOT1dBSVQ9b2ZmIHZhcmlhbnQ/DQoNCmZvciBzb21lIHJl
YXNvbiBJIHdhbnRlZCB0byBtYWtlIGl0IGJhY2t3YXJkIGNvbXBhdGlibGUganVzdCBpbiBjYXNl
DQp0aGlzIGNoYW5nZSBjcmVhdGVzIHJlZ3Jlc3Npb24gb24gdGhlIHNldHVwIHRoYXQgSSBkb24n
dCBoYXZlIGFjY2VzcyB0byAuLg0KDQo+IEFyZSB0aGVyZSBiZW5lZml0cyB0byBnb2luZyB3aXRo
b3V0IE5PV0FJVCB0aGF0IGdvIHVubm90aWNlZCB3aGVuIHRlc3RpbmcNCj4gYWdhaW5zdCBhIHJh
bWRpc2s/DQoNCm5vIG5vdCBhdCBhbGwgZnJvbSB3aGF0IEkgY2FuIHNlZSByYW1kaXNrIGVuYWJs
ZXMgaXQgYnkgZGVmYXVsdCAuLg0KDQo+IEZvciBleGFtcGxlLCAoYW5kIHRoaXMgc2VlbXMgdW5s
aWtlbHkpIGNhbiBOT1dBSVQgYWZmZWN0IHRoZSBJTyBzY2hlZHVsZXINCj4gaW4gYSB3YXkgdGhh
dCB3b3VsZCBwcmV2ZW50IHNvcnRlZCBJT3MgaGVhZGVkIHRvd2FyZCBhIHJvdGF0aW9uYWwgZGlz
az8NCg0KdW5mb3J0dW5hdGVseSBJIGRvbid0IGhhdmUgYSBzZXR1cCB0byBydW4gdGhvc2UgdGVz
dHMgOiguDQoNCj4NCj4gSXQgd291bGQgYmUgaW50ZXJlc3RpbmcgdG8gc2VlIHR3byBtb3JlIHRl
c3QgY2xhc3NlczoNCj4NCj4gMS4gUmFtIGRpc2sgY2FjaGUgd2l0aCBOVk1lIGJhY2tpbmcgZGV2
aWNlLg0KPg0KPiAyLiBOVk1lIGNhY2hlIHdpdGggcm90YXRpb25hbCBIREQgYmFja2luZyBkZXZp
Y2UuDQo+DQo+IC1FcmljDQo+DQoNCm9uY2UgSSBnZXQgYSBzZXR1cCBJJ2xsIGJlIGhhcHB5IHRv
IHJ1biB0aG9zZSBudW1iZXJzIC4uDQoNCi1jaw0KDQoNCg==
