Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6984F4D23EF
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 23:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350589AbiCHWLK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 17:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346342AbiCHWLJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 17:11:09 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA37856407;
        Tue,  8 Mar 2022 14:10:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcpQCjTllkWJHCoinflG9LwL4+S+5j5uYTg5DGXap/L26BJPRdekkefZB6H4E2LX+oHCVHWbEvVol7lBLt+XF2GvIIG+kq17xJ+i5jZJ3/bp7mBxXhuiJax1u9FjvDMnxhRkF/mLu6M3d01XhCB9fpVgUvZ1ik6DaZfgbA5XMCSbj/AyeQ/ie8QjdDG0RwtH96BU6AZ5OmIN7KPFSMzr20gRhlz0NqJxtAt0vqiK9cYVvmslEdJQBnE45W1Cc+Xr3aQxBWVFQOvImPSrkJ+ZVONb27px6TBm3qCsk0J5DYKaCfXFFrjZt9rVmbjoQFPBLe/M/mu1itUetNfzae8SkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Or5Vj+UGkYHVWsCrwW0FonkPtMM0lKwLp+AcU/RZgRc=;
 b=NPrxN5KdaZkak7YYet6xaq5htAUBkEp4Wz/7H7433agV/Wg4YZZ2EdqeZyHK7+eXNzdgTLBoFo871tr9zuIuYSLONtF9SE79Pxit9kHbIFBeVSI0YhiF+o+Yp3/hygCD2NNZfpLfG1PFg8/780biSAUMvFRcXiz98BAguzhBtKQlfnBeKyGALmvlP6l+yP+GXKncJXvmendLmj/eQVQhfCunHk4rOGM7aiZIiqjb5K4v69HxVK8N6n3WLvpeE0Rc3i78tgXycL638EjLGMkVP1hwlo2zRxUxP27eb9C7kNmjdF1W7VmL6iR7JiizN4w6FaO/yg7Ykvl7QAwkAV32JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or5Vj+UGkYHVWsCrwW0FonkPtMM0lKwLp+AcU/RZgRc=;
 b=H3LRpypb/BxDE+Uhb7io8yAizxGfDVUpZT3zyN65RbkwR5L45Nj/Qx3wOsedUYweoDkuV7wQNGQ35N9HoR6l6ELMiLH4IjP6jkyWx0GRODwileEhnwGDC0TVUdPgbh0oIbSHDyIgI+QcBfdDY/LJULFJPyogUeS0Z8mTZ3YmFDNAqS9VmRzEcSuTbOv4IVVzxIRcjK523dGm2sSBPtKcPp1AXU4fdf1RCpu5FWwwFHkpIDmq6JIYRtc6lh2dulEaXqznVsW3FOH2UfqYLpiIqBne6V10+XQ9UlXyok1Nzbrb0MKIIPMLkUF4VUKGJM8/OM5PdkJP4xFxoCMBjvBcjQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 22:10:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:10:08 +0000
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
Subject: Re: [PATCH 5/5] pktcdvd: stop using bio_reset
Thread-Topic: [PATCH 5/5] pktcdvd: stop using bio_reset
Thread-Index: AQHYMrQYlKEyuRDbnkC2Ag8SGwunMay2DSIA
Date:   Tue, 8 Mar 2022 22:10:08 +0000
Message-ID: <80cfcb91-6458-abd6-9f6b-b1bd7d7b7450@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-6-hch@lst.de>
In-Reply-To: <20220308061551.737853-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4223e0f-e720-4b76-d2e0-08da01506886
x-ms-traffictypediagnostic: MW3PR12MB4459:EE_
x-microsoft-antispam-prvs: <MW3PR12MB44590CA4E9DFE65B1B4A42AEA3099@MW3PR12MB4459.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sp7MbifuXn0LBO6SsMMZmx8na1njCNLfNY7qWi09WW1YgNNW02UUFiPbvb+WEYf044Hjr014pWIb5HirXxUVbM9kc4JAQPJYQX7k0kiVaLXgiUSorHj7LwugzdxzugxtfNjfDGaHyaRFWiBpomtnCtszPmDXUPIAL16rX8tssIZzl0oxnmz75ojYVO3hBbJ+t8ml9OFnip8aTweMRaNzG1SP+rFh0zB+q8owv+IMlY+jcf+4hF+vP3VFAiGWR1EFR8ivHTLey7svZC/DzW1hhCn34Q7aO6Qgtqge+KqAtaXgeuKUBcKFaNH/RdkzC3HriEzunih5/SjqycJA5jE3i3I3U9c/cDG7ZaxWc2PJ2fjUsxY2r1uprywMDe50HHUG+NS9BgZdY0Iehizs/N9CV0k69ZDPKjQKfSc13cszxHeAYWZT2X1bHBGE1ekDzTVJV/2tdudY1N2UJxaw7om/LdoGfa8mihzKbsbuWnGvXy5BFMDamDuOVo9TAPZ+bdF72j+3JIGuPr5nLDqIynCQkH4h01h9NnZSxQa/QmZTUTfNgxIgcH5M2MDdpc9mvAlxbOUDQwrp3v36h5gnyLCFHEH73cXt3n1I6XS4uJ+NrYjooJJ04Vq45mI5NEOQBahmoWYt6FJYha1Urldq4xFfi3dMm+1dGsKjTJOp66gzn9sQgdnL10nrBQQ3aq55mTM9/BqzPfqVz/vxdIIelpVB/Aic6EDFieq0XvRXjrmqhJgCD4gkQpJXXL/EuJEbgPsDhuvtcaqRmbHNagVw7sU/Lu1alvrXEIdum9UELfqanl0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(66946007)(8936002)(26005)(53546011)(8676002)(64756008)(66446008)(66476007)(54906003)(7416002)(186003)(5660300002)(36756003)(31686004)(110136005)(31696002)(2616005)(6486002)(122000001)(71200400001)(86362001)(2906002)(6512007)(6506007)(558084003)(76116006)(508600001)(38070700005)(316002)(38100700002)(91956017)(133343001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFBBYjR4Z0hKUjdnYVZDQzY0VEMwNVgzT1UvUDViMzZoRjZ6bXExTituRU5a?=
 =?utf-8?B?SGZjbnphenkrRjI1SFNoMW12U1cwTmRFdlhURUIwbVFWYmplYlFUS2FVUE11?=
 =?utf-8?B?VVZQMGE4WW5rUGh2c1R1QmJtNllobVN6cmgvR3lIMWxweEIzRnlacnlqa09X?=
 =?utf-8?B?VThQK0plczVmYWlrY08yLzlLUUpjdXVQdGxKem11eEhoaVJ0YWlaejFxRzFH?=
 =?utf-8?B?Z0NybEZiRGdJR0JiNjFJNHVoa0ZEeTJPUG1LOEhiZ1JRcEFyeXh4UTBieXNx?=
 =?utf-8?B?ZFlRK2V4Y2JRT20rUUxHY1VZRExjanMrSEo3R1J0d0hqM1I4SzAyMVVuaUlB?=
 =?utf-8?B?N2ZHcUJkV3pjS1lDanNlVFk1WGczaFlqbHloNVhkY1FJclZVd0hhWEIyMzN4?=
 =?utf-8?B?c1h6aUJiOVVicHhWa3prTHdsSjRjeXZjaXVqWDJqcHFkOTVLZXNuUUdlZCsr?=
 =?utf-8?B?ZW5xczBGSzQ4eEZSUlFZbzA0Z04vZWJubG82SHZUaVlZcnBucldPQTBOK21x?=
 =?utf-8?B?MTNteXZrNmhmS1BVU2EvVjFQS0FyOFNQU0NJeitsYWdHeGl3Z0NSekZvcEhM?=
 =?utf-8?B?MlM5aVJpMURnS0pmeWwrcGZNYWxsT3hLbWUxNkNtYXpzWUhLSG9yYUIyUW1n?=
 =?utf-8?B?RzIvTDMzYVVTRHBkZWtOY1FoUGZ1eEQ4d2VwbTdQeC9GQ3pvYUU3L0J6NEIw?=
 =?utf-8?B?T2RqeTFwQzlGN2l0bllGQVhHU2NVdDRUcFpuV3BUKzQvUlBMakJ2eXowc04v?=
 =?utf-8?B?ZkNEQXZpcGtwZFFoRVFERHJRWWllSW1BYmRWNVBIOWFwZHJEandUYzhMY1Qw?=
 =?utf-8?B?c2hHa01zUmdsa2YwaHo0OUFONXltb0psYytjQ0MzTlcvcU9ENTRtNkRvVWhR?=
 =?utf-8?B?Y0dPaUxVY1JJQndSMnpXWWlrWDdDYSsvLzl0Y1FXMFRadTJxSzF2VHBsMFdF?=
 =?utf-8?B?SXVORHJYbis0S0RTOTNIcGlEUW45VFhoNzNmdktBTmVsOEhIZWM2WGhacW9n?=
 =?utf-8?B?cjZDM0dkWW9UaFdwQzZEY21JYW40dkRVbW5kWlplWUp4aWkyVUg5U1NnMmtJ?=
 =?utf-8?B?ME5YV3lMK09jWFZpZE1HWDFEOS91ZEpSczI0b0s3YTZ2Qk0ydzczUG43N0Nq?=
 =?utf-8?B?VVVzeGRDa2VtNFh5S1JCVFoyKzhqdTV6ajNVNGZaN0dpK2N3c2pqL2tvSDg1?=
 =?utf-8?B?VW5Lc0pRZXFFZElMMlpTOW9kbkRZMFVCbEt0NUFWbUcwK09pd2lBUncvOHJT?=
 =?utf-8?B?S2k3a2FqS3ZaRnNxT2phSG8razhYN2gwbnh3eFZIUzFiTTVqQXllS21QOXhh?=
 =?utf-8?B?M0ErbGl6bTJUR0VtQ2lvckZFdWptWWhpN3pHZ3ZxWkNnMVoxRThsTGFVUzZu?=
 =?utf-8?B?S04xK0lZT2RySHA2UmQ3dldET3FPMkVIWWVWUUxVZXM3Y2JnYWlRR2x0akVP?=
 =?utf-8?B?TFowdXp1SlRXdDl4YXBHZUFOaU5ENVlWOSs0aHZ6UFZnT1U3VURwMVhZLys2?=
 =?utf-8?B?MzRGU0RBRndJdytqRk5lRjhJMnNnK0pwU2ZpRW5jNVZJejVTR0ZwK1Q5NDU5?=
 =?utf-8?B?cjU2d05WS1h6YklNRklIQjdtNC9zZTdSYzREamlML3ZaeDYxOTdLS1hSVjVJ?=
 =?utf-8?B?OERYa1BybE9yK0RPMWYvZnJSU3ltK1QrRktuMDRESlF5NW1BWEJpdXZ6T1Rw?=
 =?utf-8?B?QTMwT0MvWlVlTE1ueGhPcEx5Ymh6Z2dKWmpJT0hLd1haSzErWUkwem0vQmN0?=
 =?utf-8?B?Ym5GbmFDLzhvN0IvcStzeWlUbEhpREx3YllCWlljWUpCM1pjR3lYM2lzZnls?=
 =?utf-8?B?dTIwYlhkM2cxd1ozMmd3S1VWdzc5aHVqbkxIcDhIRkNOV3cybzVJaTl0S0k2?=
 =?utf-8?B?SnJtdklWSno4ZkFqTi8vd0RRdVEzNEN3cTJwdFdFZ0ZnNUEzWEwwZTNQV3Ro?=
 =?utf-8?B?b0xpU2NyWktobldZdlZsblVkdC9ub3NRc08yQ1JkVm5Benltd0N3REJXNS9K?=
 =?utf-8?B?TnZnZk8wQ2FPODQrTzZtQ0JpMC9yTVNaS0lHZXRnYkFzWkhIUE5UNm1hM1ZF?=
 =?utf-8?B?eG9CdEtRSVZXRDduRkFzNVJXQldxZFpuYkdnbW9EZCtYTVoweEhWc3RQUDBh?=
 =?utf-8?B?TFU5d3V0MDFvTk5INzJRdWZwK1NSVG1mU29zdW1xQ1dtVHhxUkJkVXFwWkFF?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16BAB11772054540B9496D6EF52D820B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4223e0f-e720-4b76-d2e0-08da01506886
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:10:08.7930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUZFs5fNpKB9gENcSJW2X9skMpBqv8bTMMQxfi4WPf5SnNn903a8PrhRF3Y2PYWo+ozfZxvDE68lIh3yzUMmqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459
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

T24gMy83LzIyIDIyOjE1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gSnVzdCBpbml0aWFs
aXplIHRoZSBiaW9zIG9uLWRlbWFuZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4NCg0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg==
