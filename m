Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD46ECA47
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjDXK2X (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 06:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjDXK17 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 06:27:59 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A96446B0;
        Mon, 24 Apr 2023 03:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOrMOXF9+bhE17lDffTFjYzmRX4ve5jYuL5q/631m4IklMiw3OP58Dsf+SEwAK6PYRxslL0dvxu+NfZmPxvwzfeAoe5qaFX+pHd2++XMEpPDSGx9ioi+rC22wV/Uo3SehGoCK2FDncuUM3lTmYPxVENKHmhKxxFin2P5gXmiL5oSmWkwnNyIv+jWB6jAaNh4wvfy+MQwWbTZMWndNdUrG5c+j17rDJQp6oWtvcB3z7mDJX7jPETLMIqCZnWpoy2xyj4CN0fvtNs5fo9B8FgZlLfZv0lokeXLUhtTKxoBIoMb1fS0F+N3eSjwrJpMr4G1VkrJTNPB6tSoENqqyER8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v09IJVi37gaa4w16EKfoWxIOEEOx+B+WmUUM1Dp4SQ0=;
 b=LJ4XpAh61PFIu+I/DQjc4B9X5izoQ4esFn3cGxs5xuFDSLLe2+vfb7iRbddA4rLIAlVLFZ88n1rQMfBeDK66qWnbOTWPXvz3ROkhTA3iId7XXHyK1rYE+Xzj0u9Uvy26WaiAYI29OZG4C7TNcwufn4i88x10b4Hw5quZ92GwmrfAKpqiIMaG3nBxNS7XOu13A1R0t1qdy5pgqptszdXjGlotclRaW2DiL+EF0tbhmpCFIFg0cjtzD4W+8LKzGPsngTxjR44ZcnQPv8YxbuDlABqzDW0YDW/0GRcoAnmwlCcYivexs9fiJ3KXWSSTCJyDmunVJ4h6+kbgQBsIhpV1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v09IJVi37gaa4w16EKfoWxIOEEOx+B+WmUUM1Dp4SQ0=;
 b=W2KJWtJVyycErwfpGnnGEKsRTgl8FUfs89/+SeztBDLWJJoIBhhPIgOu+HokYKtOQVwdqfADQVeeBp5QS3GH3ow3Ju4E1KwzGacPHBeFQZWKOF6gfRZQSJ0cPUsOMHPzi1ICBflgfVAOsLfE36C5prq7F8MMrwa7ZutFKkNYKMdeehf6b08kgamRcEQfM7/6BfyLa15BnCU/HhpepxrqdERf2lCd1PRqaWgZroBfPyWnpoyByJwyJUdar+6WGqMc+qg9LcnnPQmPLiMv702sE48D5NpxDd3/HVFMZeIQ95blD/1UOTkCrHtOptyFrDZGDy+s1xOiOumVnyU64Pfp5A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 10:25:34 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6922:cae7:b3cc:4c2a]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6922:cae7:b3cc:4c2a%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 10:25:34 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Nitesh Shetty <nj.shetty@samsung.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "vincent.fu@samsung.com" <vincent.fu@samsung.com>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
        "nbd@other.debian.org" <nbd@other.debian.org>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>
Subject: Re: [PATCH 0/5] block/drivers: don't clear the flag that is not set
Thread-Topic: [PATCH 0/5] block/drivers: don't clear the flag that is not set
Thread-Index: AQHZdn6xnGfJbIrjrUqfTU7/gdbvGq86MMOAgAAQc4A=
Date:   Mon, 24 Apr 2023 10:25:34 +0000
Message-ID: <86043b4b-0960-215f-17a7-4c1facdb0713@nvidia.com>
References: <20230424073023.38935-1-kch@nvidia.com>
 <CGME20230424092940epcas5p3407002e7d5c79593ffbafc38f2b49e51@epcas5p3.samsung.com>
 <20230424092641.u6u25eyojewvasj4@green245>
In-Reply-To: <20230424092641.u6u25eyojewvasj4@green245>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS0PR12MB7607:EE_
x-ms-office365-filtering-correlation-id: 67a768a4-d8fa-4e05-e29d-08db44ae3cf2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0CJEwcJpggcVbs2ox/oytYibSEvop5KzwV9ZAuTIH8A9KaH/yZk/bIxdjSDNV02GNr6R8WtSNGlAHG+zlzbycC2rsIKFlEDDN3lCPg9ZP4xbJjKySIIwEja0CSPHDR0+OVgIbxo8Fp2euyuhZsJY5E1ApvjehwphGXz8iYmNtEgIzVKWLNnQwGcFI4rhwzKNrxKDT4xHHncNOZHLOyg5mF713VP7UxF6Sm/xyChKN4aYLqirGvHd5sxbpr1y/UuVs4iX0zyjD1x/3LM+lFm5AinLhhL42+/E9+yRXMpImwCNc4D/+1eXBRKGCYauN7N2EgTTf0IkCAnaXXUNOWUun2kXmL8UcTo+UB5MVrFohScz/8L+rxf0wN3281wJTv4mKNng4dvxWKMaLFLe8QuGfKqwlCxUmZyRPDIVyNPOWcsIS8CnxjEtBNBqo9Ef9ngmf+T2A5ez9N4PWovjBMhVzLfVShp2i/ZhVvfsAomaeXsclezXGNpL5BbMaoH6RmT33wu9IFw5ytXo8ZvlkHuBxNE/nW6mlaGHYS+iEC6Njsg474D2ms/luVyfzXbDhLw5EKYQKjMkFwY+fX8P6drDQEQQRSWTFDlcqwhT4g6M3cK/LftGjOis0Dpj0xmqZPHQZfFafPNE6VyR3ZpFAChHQk052nu8NKWoJiUV/zS202aPybmHnMWfUyNG2NWMA3M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(4744005)(2906002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(316002)(4326008)(7416002)(8676002)(8936002)(5660300002)(38070700005)(41300700001)(36756003)(31696002)(86362001)(6512007)(186003)(122000001)(71200400001)(53546011)(38100700002)(478600001)(6486002)(31686004)(2616005)(6506007)(110136005)(54906003)(91956017)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YllYVElrN2Nyb08zZVJWc3lrdHNKU2tuaDdrWC9LMHU2LytjSDhMc2F4c3Rn?=
 =?utf-8?B?dWRqOWNyTDl2MElPdDlUM254V1MxSWhJajNqSnN4L25ZbGptTnBQNmlJb0d3?=
 =?utf-8?B?RjhocUd4RnY5OXB2cHNaNFV2em9ydEJIOHpTTUJiYmNsWENldDk3THUrM2tJ?=
 =?utf-8?B?L0JmMnFOYTFYcnFaTG1KakVYajI3YUxFb21CRERBUFBNMitvUkNoT2FTZHZa?=
 =?utf-8?B?bDhBL2pXR2toamdtTEd1VlV3bkhpSlFycGJ6OXZieHFmNjcrKzRPU250Rnh5?=
 =?utf-8?B?alJha2d3SHkxZzJ3NnZkOTc0cTBaRjJjT3pHRFVjYnQ3SVVWWVFaaGpFNUZm?=
 =?utf-8?B?ZmdNaEVRQWJpUzdPTy9SZGJORjJscTQ0d2RlbVV6aEdUMG55aDh0ejZFUHFr?=
 =?utf-8?B?eUFPVlJrbmpaSkJYL3VWWURGbE56aHVMTVlJWkJpN2pMOTNqYUFvdEY1bEFr?=
 =?utf-8?B?UFI0THJsRDNrU2tYYURHNktxQk54b1F2ejlENlU1REVOYnNpODJBL2gxTnNr?=
 =?utf-8?B?K2dOOWgwNnpHNFcxY09rQUkwK0NWMUg3VGpIS3g2eTlVVlVJWnd4bU9naU04?=
 =?utf-8?B?N2lMZHNEOHp6MyswQnE1RlBEYVl4QW1aV1UyYkZheHZDTjdiUnZZeDQ5ais4?=
 =?utf-8?B?UWgxM20zSG9DeVYzY2phU2NPbEVkb1dUdmZEM1JlbFI0dTZnSW1zNGF4RGtp?=
 =?utf-8?B?UTk2aTV6bndhRDVKdGdjTXhNVWdETG9rb1UwU2F5dTRnVnRENERQdXZXTnhS?=
 =?utf-8?B?M2VHa09aOWlpeCtnVTdIZVZKTXlvaEpDeXZmNlc5NnJaczEzblFCNUJ2Y1E0?=
 =?utf-8?B?cmVtRlJNWkRuOW1wdGhSeUcwRDFaQ1ZBaU5qZkkxK1dRdWNnWmVYQUpQOWln?=
 =?utf-8?B?OHNLVkhuT3lTWVVMTnJmT2xzNGFuclQ0bFQ5OU54aEg4djV3NW9OMnNhVXlK?=
 =?utf-8?B?OHdFa3IyYzJIMytiNTM2cEhacHR3K1RvSUZvK0lwM3ZTUWZZdkMxTkNzTllz?=
 =?utf-8?B?clB2cTJTbVl6ZXpKUmJQSjlieUJTdzE2NTJhQ3k0VTBpbW5HVFFSSXpkQWVU?=
 =?utf-8?B?Q0FaSkFCV0Y1SGhjeXk3cHZJcWh1Vk1wZUwrWklUMi9TQVd4MnU1RlNkZk9h?=
 =?utf-8?B?MnJNVmU2QURVZ0toZUIwYmppRFNkbnZZWkdJcDZIVnpPam9yK2toejBzdWRP?=
 =?utf-8?B?N0hYQmQvWElVRlgwSEp2aDlRQmltbjJDY000SlpHcy80UkhVbXBRNDQ3SG9N?=
 =?utf-8?B?dDFYd0tqQ0xxV3k2aDZ6d1JXZ2xMa2E2T1FrU1ZpVHczcUhzaWhvSWRuQVpK?=
 =?utf-8?B?dGY3VmdmUmVuTzcyQkowU3pxNEdlYVUzZ2RySFZPQ3F5T25aRUlDNi9UOE1k?=
 =?utf-8?B?NG90TW5ERXNKbHdsOWpWakFMTk5sR0Q3TlQ4VkNPS2FXWjlqMWRYOWhWR1ZH?=
 =?utf-8?B?Q082Z3I1c1pZK0R5Q3c2NWJEeTJaT2tRUWIrZVI0THQxbkhrZ3RIV3hZMGI5?=
 =?utf-8?B?UENGMlpiYWpUZzNuYVhrdjBneHBzamIvZm5UVU9JM3k0RWFBVEFoK0hMUit4?=
 =?utf-8?B?dVd2aVlodHhDYmJ4KzJUaVBqckhwb0ZCMW5sWVBjOEhIb1doN0RqK3FRcXUz?=
 =?utf-8?B?bnEyQm9SYW1nOG5yLytjRWVKaGZtbEZLTEcrVEZQWDYyZW8yY0toZ2FFRlBD?=
 =?utf-8?B?aC9hWVU0MFZGd1ZnbllzNjJjYVUyTVF1Sy9QaHFvWk13WUV1Qk40OGlxZjla?=
 =?utf-8?B?MXhtWkp4dUFQMS8xdUpYYktzUlBldWg0NEdsUWUvTFJXaGhGRGQ5dWoyZXgy?=
 =?utf-8?B?bCtjSWE4OVA3S09EZjBNODRsdkhpMVFuMDNLODc2TFk5QmRGQ0RkQmFPa0FG?=
 =?utf-8?B?STU3OVV6aEQxNXRHb2g4UWEwbEIwMXBBNjROK0pFSXdZOUxIcmJIVndyN0dU?=
 =?utf-8?B?ZXlJRHVqUFp4eXNHeUs4M051eCs1cUU5QVRiZHhpK1NJTWptd252OWZCV3gz?=
 =?utf-8?B?UnE5d1Vxb2FOamxLYWw1VEhFdmVqYUwweStmRi8ycEpibUlMVFdHNUFHTG14?=
 =?utf-8?B?S3U4bUZjaTJWSEVBK1B4QU9SM2hwSHdhMThVb0F5M2dCTm5FY1h0WHpQeGVD?=
 =?utf-8?B?dnJvTDNGVW1ZN3RQZ20vOXQyemxzaTZOOEJYYjV4dTdxYWUxdjRPZ3pVT3R2?=
 =?utf-8?Q?fWZdlATHjKs/ppvmN1X6TZIWZl0Bac++rJJxnAPzW4gJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2E587EA2FE84A4DADE419D17BA9261B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a768a4-d8fa-4e05-e29d-08db44ae3cf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 10:25:34.0438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3eWfMKDglfw7wfMsYY0Cl805MgEJFbGT0NhNon3cFEpkc1jRMDoWSSTLhnjhdiUTc9qFDsovxicuoPwscv2lFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gNC8yNC8yMyAwMjoyNiwgTml0ZXNoIFNoZXR0eSB3cm90ZToNCj4gT24gMjMvMDQvMjQgMTI6
MzBBTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPj4gbnVsbF9ibGsNCj4+IGJyZA0KPj4g
bmJkDQo+PiB6cmFtDQo+PiBiY2FjaGUNCj4NCj4gQW55IHBhcnRpY3VsYXIgcmVhc29uIGZvciBs
ZWF2aW5nIG91dCBtdGlwIGFuZCBzMzkwIGRyaXZlcnMgPw0KPg0KDQpJIGRpZG4ndCBmaW5kIHdo
eSB0aGlzIGZsYWcgaXMgY2xlYXIgYXQgZmlyc3QgcGxhY2UsDQppZiB0aGlzIGdldHMgYWNjZXB0
ZWQgSSdsbCBvdGhlcnMgZ3JhZHVhbGx5Li4NCg0KPiBXaWxsIGl0IGJlIGJldHRlciB0byB1c2Ug
dGhlIGZsYWcgc2ltaWxhciB0byBzY3NpIGRldmljZXMgYW5kDQo+IHVzZSBpdCBmb3IgcmFuZG9t
IG51bWJlciBnZW5lcmF0aW9uID8NCj4NCg0KSSBkaWRuJ3QgdW5kZXJzdGFuZCB0aGlzIGNvbW1l
bnQuDQoNCj4gT3RoZXJ3aXNlIGxvb2tzIGdvb2QgdG8gbWUuDQo+DQo+IFJlZ2FyZHMsDQo+IE5p
dGVzaCBTaGV0dHkNCj4NCg0KLWNrDQoNCg0K
