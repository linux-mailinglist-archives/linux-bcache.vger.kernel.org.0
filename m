Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DF4F6856
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 19:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiDFRsL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239714AbiDFRrb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 13:47:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE5522F3D1;
        Wed,  6 Apr 2022 09:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3jLqLpEdweFTzXRYZJVagyyuFJo6du9dux/luLKNiwp0+ENU02EumCxpYGQxNpQAUWtcwImGph6+ZFGLPPMlbau7EteVsBS/29EpMID3zAk4V5IvJxcREFoNjbsN1MhAWZ3ZQaTh//K3z64j1Tq4CwF6dNbzU0nD2rFBouHsS6HADa2MjWq3RirmlSq+1h48DSjfhQB3e8VaYm345RpIkX2cHoFvfw0l0tWsx9gDdo0SmhEG9mCfCvGuvWd+on2H216p8QJ6W/RT8/sfQlnKIgdO+fs4WpqWO6Epi4FWq3iak+e3wwCb60eky0V2qpZc+tBLVqsAtE9ql83MdoOhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1PlTr/MrfQ9HJc+Swapi+X9OU5zXy1Guh7rmCQJkwU=;
 b=hLJ4P2eUcM0prLgvG1hfaHLLVq5baMS8qTVmfptWMYRrlX8o/aD8+WdUpzA7SAd071sN2KwEC4C99QCc6XOdDp8E+r4jDiCosuXkbWlWWx6YHKxxFqRwR3fuFyeZztpUPysHZuuQTWLH5xIzNsT9lffBxvMFfG2RbfQlm5zjwnLsNruJB887i53E5a6rQWR1/poYvFG9JXtHciPqDIXeVFdxEyetZJnjl/bf9Qg5FnJ97+qbwf1/Lv9esl9zxNv1IA/qq2wlOMleUReqvOZD/ueN1+8qzembOTkFmTZqMfMhKKh45aFRQ66wPPIJT2HpJjo2GAUPnSyOitdMh7Ijvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1PlTr/MrfQ9HJc+Swapi+X9OU5zXy1Guh7rmCQJkwU=;
 b=Jfcx/2PpgbBX2z2DHCkKWuHpIqyheXqM9W9vjwIvlXNGlfH8dnUIKrBaXkp+aV51AcjgNNDn+cteNA984aoSfhmOA0QWLpJHLLI7PAutmfC47fLMGyNux9+heAi6QcgH2Oped2YVBmx8EcvIdIwaDXH5w/7KVvlBEuXHLb7vAqjUlzcRoHIVCszMvDECFs6jO1gY5DQvQT/7/iEHKrzRgNYYqVK6T+SrqEHXZ0B0iHsXZ8Iq/gl+132dlcWu/IxY0nDlcsBGkc1u9DjOfiZLgoyp5i0+h04xaxD3KnyQAFA1pQ1k45diIJ/70XOYxzjA3/zBEMGBA3sD1BRgTiZLEg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 16:24:45 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:24:45 +0000
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
Subject: Re: [PATCH 2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
Thread-Topic: [PATCH 2/5] squashfs: always use bio_kmalloc in
 squashfs_bio_read
Thread-Index: AQHYSZjNtRgeK0B4G0+ZE2vgbni+t6zjEnQA
Date:   Wed, 6 Apr 2022 16:24:45 +0000
Message-ID: <0a23a8fe-c298-3fa5-5d50-55d36d9bd14f@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-3-hch@lst.de>
In-Reply-To: <20220406061228.410163-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26a24fa8-2943-4c4c-94ec-08da17e9f655
x-ms-traffictypediagnostic: DM4PR12MB6012:EE_
x-microsoft-antispam-prvs: <DM4PR12MB601230E3E5C83372FF12DEEFA3E79@DM4PR12MB6012.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lih0Fhptg60aQnfpp/kwAO4pd/dk4X8DFJTFzV8dfrfddIHc6e53aClfCUDq7eCnxR7+Ie5aMLcGUG24Ah7ESjtyJLdfwC4hlcrukUSRqondoxNdaKy8rWb/MHdMi/OGFBD5GYlntN1diIQAr+YN+8yFf2YI0xq0dLLnGmvGVCh4N5Ox7pHElUSQ/33JfMMaLDBSzXhzNf529JWIr07IT+zMXL+864zC0xs5s2XHkiibyRGezuDNKYHDbRhSFZdEKJeg6/fgFTD6Nirnxagl/HsmCsBGzicJS89mbUnOPQ0grV6H1pi4HMuc1Au3SnkxaMFEXfTzDFH6q3rBL3Y+ifRp79vCyNRXaYHB40XaXh3F0gZUZ1VzmdMwtJK4t5OIILK+nKmLL1eGknb+y7ncEMb5/WJGedPIYTuHm4HOL4qVmpz9lOiJ8P1o8+CZzzw1ue+4YRQw9bCpFW6wQxRZzA+i/5JlfElkaVhM5TBTBmXCW3pOX4RBaVYpbBgo4AEmTqLN9QKJnb4vRUFoAlIgZmoKue3jgeAb2ZClGKGmMTrZjCdVBYChvTig2NMSATeKXDXPfVgids9GMnPsdUwxu2wndSWYEA9juzKn0BbqyE15g1NefZapzYz9fckOg4vZK9J7Go/QKx7kyo+6OFO/N8BajT0oed6jDkPr0k3Mb2n2oRwmrEq1aVUUAWbzSikYHAfzfm7H3hEHiA2DFaoT45PebmLhCyP2uUIe2E2o00vNZ7oZzuSq95SNo9Yj+1HNGjV4Pi5TQyW1OXJaAA96UA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6512007)(71200400001)(86362001)(31686004)(38100700002)(54906003)(38070700005)(316002)(110136005)(31696002)(7416002)(4326008)(66556008)(66446008)(66476007)(2616005)(64756008)(36756003)(186003)(91956017)(66946007)(8936002)(6486002)(4744005)(122000001)(6506007)(53546011)(76116006)(8676002)(508600001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUdycHFLQ0JYSDRLMnFTU1V2VnNtTko2MThzZGt1Ylo4SUc3K0RVdTN1SjE1?=
 =?utf-8?B?UVVra3RWWjg0OEJTOTZtN0d1TnlDbGNMOEdBYUUxTEQ0ZHZSQXhxY0pHSE81?=
 =?utf-8?B?bTJFYlBpUEtLNjZLZ0pqa2IzY0hkUUVkeDJicVVoR3lwYktjaW1BR2t2N0Zx?=
 =?utf-8?B?cE4xNzV4VEY5RE9yQnFHL1E0Y2kxWlA2WGNTWnppOXY0REZnT2NaSW9zZUQ0?=
 =?utf-8?B?YnNaaktreVRWdVVINndvbnJTMVJvSlFSVHQrZk5aQmtManZJRkxDOVZBUEFv?=
 =?utf-8?B?ZlRtMTl0Y0FERUZqM3ljRkVHU0RoS2hUMlo3bGczMmZSRzFHMWtLQmt1RjlN?=
 =?utf-8?B?WXZLRVIzOVROcUtQaElmS0tmQnRjQzFpUnpPcVludnZUK3ViL2wzQU9Qd095?=
 =?utf-8?B?T3RsZXZYT3hQZlA2T2tkYTMxKzZaUEt2ekpvdmNNN2FTVWdieWYxK0VFeDk5?=
 =?utf-8?B?alFRazgrTytPR0lSUjFBUHplUE9QS2t6aWl6ZXhuMGNDMWh4TE1kcW1qczFS?=
 =?utf-8?B?YWZKQ1l5TTNDMDd5bFppQm5WWnpIZmpWbnFhVjl4eHJGNnRLcTZrbDBjNTM4?=
 =?utf-8?B?bTdLYjdEWE9NaUpuSEZBcHJOMHBvV21qVHVwdXBRSFpZdlpxQk1RWTZnVHJW?=
 =?utf-8?B?a0xBVlhFMG5tUlJCTktJZFhIemg2ZnJQbUNISU5RTlNxUGVmOWpzYjZtR04v?=
 =?utf-8?B?VzIyTDNVSEd1WjIwdHpNbzczOFF1N2F2d2xidERwbWFER1dzeHdGam1PTXhD?=
 =?utf-8?B?VnBpZno1bjJCY2Uvb3RKWjRLUkFadzlqRDFWSWRlUzBRL3dYbkxYQi9SbWZX?=
 =?utf-8?B?cW1Fbisvd291dnZCVzRLbHpuN2pKbFBGcVZwc1pLeUxHS0QrQUVteVJycTRx?=
 =?utf-8?B?dTI3UzVCOW1BYTdIU0NOaFk5ek1OZzNQbWdNUm9PSkNnSmNWa3A2MzJQSG9X?=
 =?utf-8?B?S2kyMTR1MzRBZDZDNFM1WVY4ZXB3QS9rK3VTcHU1QVpLQXdrSkxaSWVBcGNX?=
 =?utf-8?B?aThNZjFPaHBOS3ZtbDVjN3l2NEVIVTVWTUNvbTVVLzBuR3NsVzB1R2NDb1hI?=
 =?utf-8?B?K05QZWU5MlllSTRwNFNSWEhHVmhBUXBwZTZTbE43Z1dDazhYZkt1aElXWTdn?=
 =?utf-8?B?TzJCQjh1bTI3Ujh2SitnNUp5cUhiQ3V2eFZwRHZWd0loZ1BONW0rOExPYkFO?=
 =?utf-8?B?eUpYaHM4Z2VVR1JDYllGQ2wyN3p2TGdKQ3V0RTArL1lZWEMxMDRmZzkwT1dm?=
 =?utf-8?B?YVpsaXpvQlJaQTUyMlcyUDdnVjlNMnFNVFdzd01aWnUyM1FYMTc3ZjZYRG1S?=
 =?utf-8?B?b3ZDY0hpZTBsMmZMQ0Q2NmZzT1dkemdrVTMzSjF5N1NURlR0ZFpNc1RaYU90?=
 =?utf-8?B?SUFGNzllZ2FzeDJtQUhKNzljVVdRbVpyYmEyeEVWRlB2SThNQ2pBZDduME96?=
 =?utf-8?B?cEtITG5Bd1pldzBOdytVZHk3K3Mxcm5yWCtJamdUVHJ1WjFHejZzSGw2dHFQ?=
 =?utf-8?B?K0NENnpwblUreVFIbFhONEF6Q0FuQnF0clNhR2kzd0JDQWNsNUlsSmxSWkVW?=
 =?utf-8?B?RlBEejZwYzYrazM0WFE0eGt5OGYraCtneVJaaW1hdnBoUm9SZHRWUVllamdR?=
 =?utf-8?B?NEdPS3dOWVpJL1Q0ZU16KzJ6aWw2cEMxcHdXMkpTQWdmYXo3TkVWcTRabzZ4?=
 =?utf-8?B?TFN6OTcrcU1EdFJkZ2puallKUThtb2ROOEpoTzQ3aURlOThFWk52TWQ1ZjBj?=
 =?utf-8?B?djcyWWZXV3c2VFNLdUFCZDJybEtjWGhUQTB1bGdrWmZvSDlxZ2MrcXRBYi94?=
 =?utf-8?B?NEthM2JEbnl2dDU2MTBHLzVRdlNlelBMYnB4WXAvdmdoSlk0UmhoblZQd1d6?=
 =?utf-8?B?eE15aUtPWkkzMHh0TW5MMjRwMXM1RndrVCtPdlJXem1lZ0pxdmNqVjZQVXUz?=
 =?utf-8?B?VkwxdDNiVkFweEdFbmpHa3l3TksvaFgycXBSLzlQS29PemJPTVlWNGFkanFt?=
 =?utf-8?B?UmFIWEMwM0haVEUzYVBFdFIrRldTWHlUNXVrRERkTXRRRG5rUnJQc2treVhm?=
 =?utf-8?B?dGllOVIwdmR1dEZwWTlRMkdDdEFjdERRWC9SbUQ3TStzY0paMnYwYzlDdGY2?=
 =?utf-8?B?ck5QMnV3Y0pSMmI0QUM4NDBxblBHVlAvWk1Lc3orc081L01ZZnV2SElGNCsx?=
 =?utf-8?B?QnZOdEllN0QzcGJjRHlRb3ArV01PU0s4UkFXeDlGN2Z4L1JHTG9xbnA4SW13?=
 =?utf-8?B?NHU4K2NFUW96YVNydjhQNG1kbCtuY1ArWEhTV0VCalJha0xVb3hkVWFFWFRx?=
 =?utf-8?B?NFpaWWRXZWZlWlNicVloWWx1NmNRSWpYWjRhbjdWQnk0TXRpczNPTGozZmJC?=
 =?utf-8?Q?ZJuk41gmAUcJIu6E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58EA1AAC011815489C0953DC4A7631D5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a24fa8-2943-4c4c-94ec-08da17e9f655
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:24:45.1313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/BAfVFG1GV7EpFQMOB5J/nJP9BCszDUtIhMNKcIn9IabiecCYq+72EED58+dOSHFy8zWDa5ksvTqW/JFqBScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gNC81LzIyIDIzOjEyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gSWYgYSBwbGFpbiBr
bWFsbG9jIHRoYXQgaXMgbm90IGJhY2tlZCBieSBhIG1lbXBvb2wgaXMgc2FmZSBoZXJlIGZvciBh
DQo+IGxhcmdlIHJlYWQgKGFuZCB0aGUgYWN0dWFsIHBhZ2UgYWxsb2NhdGlvbnMpLCBpdCBtdXN0
IGFsc28gYmUgZm9yIGENCj4gc21hbGwgb25lLCBzbyBzaW1wbGlmeSB0aGUgY29kZSBhIGJpdC4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBB
Y2tlZC1ieTogUGhpbGxpcCBMb3VnaGVyIDxwaGlsbGlwQHNxdWFzaGZzLm9yZy51az4NCj4gLS0t
DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBu
dmlkaWEuY29tPg0KDQotY2sNCg0K
