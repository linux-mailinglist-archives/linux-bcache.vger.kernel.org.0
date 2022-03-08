Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F04D23E1
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 23:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbiCHWIk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 17:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344879AbiCHWIk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 17:08:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10632DF9;
        Tue,  8 Mar 2022 14:07:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmVTytU22Vw847gTrwCwUYGx8roS5EJ+39GIsdVOAwayml9Emh21WHhtvTQeAiJzmHZkPQ23nJ1y6/dAVJ5/hF1kMcQ0giwNUh5DR+dUEGDOh+XdE8Ud2CbKpj3LTn2NWfkxSSBbUO5GGWZrCV1QQo1vJXsClRSbDiDizQJXbZjB+tCu/7WRk5pMplLWU/IvHrmK0UBQgbMhXuh/5y4YQlLXX+EdCT6rp/r8N4MxJa6owCZbktaZVhIfifSigpYmGP8bGzZffBpz0SMqK6z9mBo38E/Wv3jyils4ULQRJY7vy10hqn4RFQd/YYNRqQY/3+JKbrLDxGikr2W4S5pDqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+FWP+LlmeUdtCRg3MbmNBaNeOjjxNrjKfavVj02F5c=;
 b=HuqSSGW6uuXnzG9R0fxM/Y19/L0BlswWlzLHP3FWPbmlRdoY+lDI4ouBkTJQ0pqR+vpnOO9q1Ze7cwhtc/+SEH3Lr30Z4WNE/1qrUd1WRlmORfNrkPyfaDKaBM6xO7yho4aj2x0la8wgwEKM4KD3Dm8K72AP2S8QKxuzmOwA6S0IPD6ahIXA8ThzBB27gv5fc+xV7fHpbKwmLWyXuX9lW+aiLrgIDL8Pq0T+rn2BmN3CyruSw6U96huudQeZq+uadTvKOHm7uRGrCbPFRp2gaSnnnUByarjNQfILS0F7UIpLrOPb7dIaER6k3XFOYNACvULoj2v0yg+OMLXs98lwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+FWP+LlmeUdtCRg3MbmNBaNeOjjxNrjKfavVj02F5c=;
 b=M8hDptac4WtTrkkkzcKiQE8/YiP+0b9X3vqQnCVy7TcIRzojs93+xAHvJGpvcSctYyjiunSzscd4qn/olgdBjSUtKq+6DGEOB9VCkSR7wwQDBsyFtZGVkBTdRYXvEvuxHNMPCRez3IbV0ZBOZZgrXj+VvnAKwWdvJZxmD/yKtucXIaS7FpIlrxYYWL8xVHAk1FXrMbPFA1cplS4MQyBq8E5NRbTKSQyHnSn7wOSjLz8Evhygy1JkF9H6DqpZYb8x1bcwhXq6nv8I0FSQkgrUlYkAV8h3sxnI6tPJYoioDsFGUUYKnL7bruIkKYf/1WOQ9ABY13Ufh49fG0J/R+S7eg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1446.namprd12.prod.outlook.com (2603:10b6:910:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 22:07:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:07:38 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Thread-Topic: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Thread-Index: AQHYMrQJiBMQoCadmk6WQuobhVgjTay2DG6A
Date:   Tue, 8 Mar 2022 22:07:38 +0000
Message-ID: <9a62e88b-89dd-2420-2551-6f587afd5db2@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-2-hch@lst.de>
In-Reply-To: <20220308061551.737853-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a364bdd-af96-4363-cd32-08da01500ec7
x-ms-traffictypediagnostic: CY4PR12MB1446:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1446E6354A2539FF367E1ADFA3099@CY4PR12MB1446.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lKyoMo36d9UhgqgpuVXXX/jUxoDVDAjyAsUq6dxBCgFyU/CrASs90weMJSi8mTkLxEUEStzIjOvY5OR/unUtMNSMUMtE2RM8BuhDyy1QXqlCSv4JBwbdzeL6k7okaHzljj8ZVGrfU70oBh8L0D8IMGUqHsB9vrCQZ9Qu62gcJHQBmvWJ0f7l8WAP7/7QNe3BKysjuc0n6JcT3+mX3mBINzRVkB5IQzXoJGNEp/FPGwhjds9ctUQtqAgwS8bcEIOs0SbuZxGzns8L5ODfvWFXz88Rst771SWrAQIh6Tx64t0Hra9UvVyXn5shfEn0mbjC9fEP1x2sfxyrqMnrmiLkq/CpOjM6e9cHMp1N84AmIrxYwgbZ9bHFyZwkHJRj6rwK+5mgLZ7M+/6RsvmQy2nNRZf6j0v4x5BIR4eIVY94kTkVowWFqAOGHs6TR3zSfFpeoUsVAydMxMx3rAGFX3OytLxYGyHRP5v3CsQpf/4dHG5GlqDWxDueKuHzc5ADQRtAd4r0BEoO7XfKVK64RHsJaRbGW/gCQIGX8MJYV9/OpKAjgSQBnIYgkUmR2V+JfR0mkctr8HDkl0Iq3Di7xYJVPW1qNncT2euNMh7O6ozArBsfjlFaeVYHLOw1tFZv4UirM4ROI8Wk6mW4Q4PLTalvYRRNo15SKi6Yj0/BHcz6c94X3+zz9Q7VMMfSVdIl8qOOmhO9KWaXD8yjbyd4qNNO1Ty77akBd5kCmv5fSKUSyAxnV7pKIk36+AWIn/gqvt7uv1+TKZrSh2zakQ6fTo8jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(5660300002)(91956017)(8676002)(66446008)(66476007)(66556008)(66946007)(64756008)(76116006)(4326008)(558084003)(316002)(36756003)(2906002)(8936002)(7416002)(110136005)(54906003)(38100700002)(31686004)(122000001)(508600001)(38070700005)(6486002)(86362001)(31696002)(71200400001)(6512007)(53546011)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmdoK0RkVUJWMDk2QnFpSGRHNHJQY29wWDFFakVMZlZiem5WZ0doNStrWmND?=
 =?utf-8?B?RHFMbENxRTlpV1FxRzV3QTR0R2UvVncwcWtoQ2VucmdxZExoUGdlajNtRkJ0?=
 =?utf-8?B?bThaaDNWdi92MXNwNVBmaVFIWEtPMDN2K3Y2Z0RESnRkaWIrdHowSjVpdEVy?=
 =?utf-8?B?YlZTajZrL0U2d1lGNlNOQ2dROUl4c0kzNzJWRythOEpoQ1ErUGF6bjlCRHdr?=
 =?utf-8?B?K0o3OE1HWlBybUwzKzJHWGZxOXBUelVCVTB6ZmVZbHpSbHJyamZPVFlZNDdq?=
 =?utf-8?B?VDkxbnRySUpLTUE4K0g0TEI0RzdHTUlpeHlPOUhQQWJVMnlTSnhidzZYMDBH?=
 =?utf-8?B?Snc5TTk1ZFFSN3dxK1dyWjRNeVBaQ0NFWmpndHU3bVcrV21nM0lPWVByakhW?=
 =?utf-8?B?T3F5S2tLRUI1ZmZiSWZhdE9OU3NMNHp2STBKeE1UNmpOaUY1QytpNXFUUEVa?=
 =?utf-8?B?NFk5czlBUE03bXlVMk5OUmxYaXBLZm8zRUp2eWQxZDRmc1RQY0QzLzFWN1hH?=
 =?utf-8?B?NFFDT2c5eWV5VlV0cGppYTl3c0N6L3BmQWZjOVdvY2ZWRFZlNXorUHhZcXdO?=
 =?utf-8?B?ZUh5L2lLdWhodm9lTDhFU1lWT2tVL0lDMS9ZRW9ycmJHMW92MmFvNlVMNTVm?=
 =?utf-8?B?VTYwZlVBY3hXcTdjTnNTd3lMTmhKU2E5aDU0OENub0MyUmFSOXVmSTZJbFdl?=
 =?utf-8?B?ZGQwQ3VVR2dycGg1Y2pSMkd6NndLMk10c3FIczBxRFpUZ1V4ZG9GYkZHZkoy?=
 =?utf-8?B?WGhIOXdCSW9DSUIwSVlpVWZNYUN2NE9nckxSWUg4TGgzcDdidTkyV1Bjc1ZI?=
 =?utf-8?B?TTdzYU04SHR5eVlDdTBhVTlpd3VGbkNUNnJLTkl2aFMydno1UWtWRzIxMFlj?=
 =?utf-8?B?aXk1MWNiZ0NQSXVZdHk5T1RlZGFiMmNYVnlOZU5xTThIck5MbHVXbXJmOEEz?=
 =?utf-8?B?MlFndzRSa1hPUTFiY0xYQS8waWZrNVVUL1pFbmh5cXVkV3NCYzIwaUsvb284?=
 =?utf-8?B?aEJOU3lzY1NNc1NmWmh3dlhoTGk2VnZwcW9PbklDdTZUKzk2ek1adVNaRTg1?=
 =?utf-8?B?WEZFSUdWU3U5c3JzYVd0YXlvQnZuVTBZYTNQY0dPYnBHQVhtK2N1ZjRoa3pW?=
 =?utf-8?B?M0FDWENrdWZjV01kSjA4MUpJUVhYZGprcmtPYVorV3FQUnZqb0FiZW8xelFZ?=
 =?utf-8?B?MW4xODJiZUpkNjZyWk11UTNMMjNITERVdFlKWTc1bmVyOXZha1Zwa1NONGdR?=
 =?utf-8?B?VnZsWE5INDFyb0NGTmtabWpBNloyaTJmUWM0YUpmZ25scXNwUG9CU0FiZVI0?=
 =?utf-8?B?ckt5QmNzRy9oMVRHcE93ajhPMmE1VHZwbEVKQWlocGJ5ejg2V1ZyU3h4Skxq?=
 =?utf-8?B?d0RTSURTVko0Vkgvc1dlV2R6dGxsbEdNQTltSFZSOUpDK2MxMUVERGpKUkdj?=
 =?utf-8?B?Sm9mK0JmYytjMW0xQS8wYVA5TDJOeHFnVCtTTmo0OXFyQkdld2JuZHVTczdj?=
 =?utf-8?B?ZEViY0JBVEViZXVucklhQUVFVW56Zjk5TVZmdmRhQjkvbFhpaGIyZW9hSHlU?=
 =?utf-8?B?UGcrY0RKK1NWa2RVS2hpK3RXK1pEQ0xVQ08vMmlnTUtLaGdSRmg1YllnSTNH?=
 =?utf-8?B?a0VEV0NaK21wYW4xS0c0Z0ZzNWlkQU5vSUU1YWhjeW81OUhmRWhCalJiWkxi?=
 =?utf-8?B?OS9LV01EOVZWQWdOQ3BBZnVIakw3cXhkL3hzY1Zka1dOdCtjTi82M3Y0b2M4?=
 =?utf-8?B?Qk1DTGxKV0lIejdRejArVHBwcDF2VnN3T0ozZlN0RWZKNnU5UytRaGc1QnJL?=
 =?utf-8?B?OXpyeXROd0IrRXp3WWpTN1kyUmNrU2tvMHRXOGdZbktNY3N1SEZmRy9PbjVh?=
 =?utf-8?B?blhWWkc5V01PU05Heis2RGd2U2dSVVVKWi81WGMzWnN6N21YY3E5bmxqL2ph?=
 =?utf-8?B?S2VpWm5OeVJNbUpXdUFST0VxaUpQUzdqWk9WSWpwMmc1cUFSV2Vvd1d6SHMv?=
 =?utf-8?B?U05LZkxDSHVJS1NJeFQxQU5TbzQ0TGFsNXBBQ0t4SHZxNEkxVHQ0ckw4QjYy?=
 =?utf-8?B?Q2dRcVRTUVRFZ3F4Z1h3NXZFRG1TQk94NGdiOEZpZEhMei9rM2hrVTBRT2Y3?=
 =?utf-8?B?MzlWS3JPSndna01SZUNIVDBBUlgybnRYaWFnd3FoS2FKcG0wc25JNmJXR0lM?=
 =?utf-8?B?NFNuOVRFS1JGeEV5dW9QSlhnRlZWQ1dFbWN5NUNsY1dwNHYyd2Y1L0xBVEhk?=
 =?utf-8?B?UDdTd0tyWlJWYkpPQ0pUandwOEJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1D4ED73BE2BD1418E9C638FB9C1AB95@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a364bdd-af96-4363-cd32-08da01500ec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:07:38.2395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUM0prCgr7LXXJ5ffJ+YbwKYq3VQH+1X7BNC5Sl2UQvZRoVVe8ZuGiXfTl/uGw1tEVrfPGD0gmwjdUGDN19FFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1446
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gMy83LzIyIDIyOjE1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gVXNlIGFuZCBlbWJl
ZGRlZCBiaW9zIHRoYXQgaXMgaW5pdGlhbGl6ZWQgd2hlbiB1c2VkIGluc3RlYWQgb2YNCj4gYmlv
X2ttYWxsb2MgcGx1cyBiaW9fcmVzZXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IERhdmlkIFN0ZXJiYSA8ZHN0ZXJi
YUBzdXNlLmNvbT4NCj4gLS0tDQoNCg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hh
aXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQoNCg==
