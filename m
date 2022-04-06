Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8454F682A
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiDFRq5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239603AbiDFRqt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 13:46:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB881EF9ED;
        Wed,  6 Apr 2022 09:25:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYRcT7mPbhwwdZPcoYuqNHrSfR5WV/4TLH5JC1OnzkIL7lc7ji6EPhRGIS8uVd1P3/3oewL+M7uUgBjncv7I7wY8AMjNFozc63+DjsZ6G83ngFBaaBjN/1z8krvfaJEIxACP72k0v0z4BnNJ16D/benvW8HhQUslCaEYNhxutvn+i5YBSBTkYXNCLcuveFHjCsGe+PH2mOVhpzl7Nbqh9v610ZYEhoESPVJDUMUSj0s/ff6dRQSEmzzZdSJf60OrB4gp03Sbb/EkCy99hUCGFPu52k/loKSphfSjhSFQvb1FvPI6L/Ms6H+UPfZ7n2llCsay/RrGxr1zy979bDKdYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSuG+TTQrF7JvNDFXM36ICYOKpgj3cvGI0R4ds5p1bU=;
 b=gUn1mKuxU1ktM2D57RbY31XLIjUlziAMXxMm1kPKcKwa5B1dDyvoaCMgcJJTG4W7AusOqWPIvbBde2OSU1SIJol6q8ajfB0TmeNzxKAXqQ1zTq87GiEWpEn/x2Hk+62taLsWnYooQ+DtX3KdelBubn5F/JCwpuvkP7qlABmZB2EdgPvQ80lAUtBAroGLr8np/XtVkru1/uB3ZCLQEt/p4UgLhEQomPfP3RIZvqdg0erixkh9nMmRtjN4JxW+yGmj68PSVnMlQ4yUI2BvBE7+NmgpdisOADm6wVQnC7M5qplntc2+GuA2Q0PNKT8JEydKTWzMMdSW5u4+QyNJoNKyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSuG+TTQrF7JvNDFXM36ICYOKpgj3cvGI0R4ds5p1bU=;
 b=l8b/krjP4NmpvoTPOdUJa9qAmsG4lLZjsLLOn34xwIUp5dxN1sPY1uYAHteFktpv2tsBjnIQhNtBjvX7Mv72jqndfp0hQ0sgTlGbL065DmVtt9orXrgI/SlpmYyltQ9WHOwgfBdIOZfPr0g4h/gC8kWZ4//BKEHKPViH81XdjivknNy8TzALiplV7nxREZdWSugtQ3+H4p5NsuXUqyuTk9za9vGuSCHweSxF4kUdR97/atXxvnppjUJD0NRz9XeS/MNZR0zOg6B0/V2G2QQhqpL6pmBwoUFgqzLABtpp00mPHhoWMZftbo/2hxhdjSKMKYi2meguyJrG2iDy6lEy9A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 16:25:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:25:17 +0000
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
Subject: Re: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Topic: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Index: AQHYSZjWHWW7ZY8LCk6qHnPXNgEM8KzjEpuA
Date:   Wed, 6 Apr 2022 16:25:17 +0000
Message-ID: <cdae813e-2e2d-8900-c48c-e36f3fc3314c@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-4-hch@lst.de>
In-Reply-To: <20220406061228.410163-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b69e6288-764e-456a-6631-08da17ea0995
x-ms-traffictypediagnostic: DM4PR12MB6012:EE_
x-microsoft-antispam-prvs: <DM4PR12MB6012E369A1F0FD1F65A7C152A3E79@DM4PR12MB6012.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JWuAhWb02X+5TwbHjumMFa8T1iMu7wHLneNkIQGrhXne8Uvyz62gIGdGy4dv2HDOcp1u8t33fB/8/bNWsYqFJeGseq/wVhhKyuvosJXDLbr1RhP96lDNxgllqi+8dIbENQafvz1IcqA2Jhs55bqIMl5vWPjHOp1RCZsRytFZvR8TptdZjyqjzzaH2QMGLdJD3lu+vnWaeaPO524cdp3+LNSeJkg6ScV9ZkJ7viCGUBbzSyDrnSFXJVkhYcNQO04Nmwdwm3+MvSJwFyJDaGN2FvzmByaWacUGNRCiBLenjas3wla65jSRC9Ry00pY6okHdZv9is6jkFJvmPWcJdE7bpHqcVeCAY29MiCGX04orQViYvRb8Cr6ETJ5eOPOg14zRqBZaHR7OL81Aj3/JjvnXWkyicp6dLzbKhoYsT770uViHX3kGNxUaaz8bvfgp7mDK1+fmj356MZekDQjSxHRWAZQdt3+SEFnlmOVT0KLw8b5M6ddEuOJC2d82XmAyzGvfaFMNyr+Mwj2RIiGlTZAWupBEth/i0dCh2xsJpFC1Qs7lKXCxOWqXSJiy6XAYTAUvdr6+itkkReCXInOdYf0GKxISkfjMeSuEdmxwiJP+RfbsyKpW6fYYe3TaRvpxJ9vLiDpHWn4A88iwL3pzHGAf1EMKEltP7jLfM3LyZyeETDqKpbUdoR1NagWGLkss45htSPOEXNJtkKwR8Wi+fzBgr7aCCCWgXVvsnqYO95gBDIug0F5tgGJkdy/yO5e99ROfB+hqYsXDJJwuGVLaNaTmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6512007)(71200400001)(558084003)(86362001)(31686004)(38100700002)(54906003)(38070700005)(316002)(110136005)(31696002)(7416002)(4326008)(66556008)(66446008)(66476007)(2616005)(64756008)(36756003)(186003)(91956017)(66946007)(8936002)(6486002)(122000001)(6506007)(53546011)(76116006)(8676002)(508600001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk56OUxkeUJER2ZZRU9aQ05QSC9UdVlCUFRGbEI5YUVLQ0N4a21OR0hldThW?=
 =?utf-8?B?UnM4Wi9vN0ptVTJxaEhQOGc5ZWZuRzBrZjhCRkkyWWpHUlg4RFBXTE5iUmRF?=
 =?utf-8?B?Qm9INXNSdDBabzFnRDFUSjc2bTVaeG9WMlJUYVN4dGZiYlg2K2FSd2g4emc4?=
 =?utf-8?B?aWU1ZEFJemFuOTZZUnozV0ZDL3MyRlVZMW1PdTlSeU1VeVB4KzhCTmJ6d0ls?=
 =?utf-8?B?Y1NpMjVHbmh6aVd6ZlZ6TjdzTUNjTDNITTNJVGdJQUR3dHJwRTB1NVhqVEY2?=
 =?utf-8?B?OWozZGpuKy9obzhiajNkeXkxby85U2h2RlY4eTlkUit1YitJWnBockdNT1dV?=
 =?utf-8?B?bUJ2Qjk3L20wN1VtZFFlSS9hc0ZITThvY1JXSysvUExEZFg4WEpHVllsWFN5?=
 =?utf-8?B?YjVHTjYweElRSm55RFZva2ErOGJVd0c0S1E1MG4xV3dTQVcrVlh6d05xcXpp?=
 =?utf-8?B?NUlhNkZoVEkxeEV0enoyM3JPejNGbGNXYkhuTkFXYUsrcFpwMVFGMmMrK0Fn?=
 =?utf-8?B?cXlBdVRMaEhKWFJ3STdZR216Qnc3YmNrTkJyejd2a1NTM2NDL1JpOWZNdzFS?=
 =?utf-8?B?VnZLUDdXQlJyck9SN3ZPWCtvNVg5bGNOUEZxb3JPcE5QUzJRblJ6dFR1OGtC?=
 =?utf-8?B?R1dsYUVOYkhlM2hwdzNtbUsrOEp2a2VEbU1objBsNmJWaG95ZGNoME93WVRI?=
 =?utf-8?B?UDNtZjVXQWpTOHIzdDNpZStFVkpGTklQb0h0TWlYWjVKUk5Kam1CVUt4MGk4?=
 =?utf-8?B?T0VVK0ZEYVl6QkcrUmE5dGNkUUl0ZWtnV1lkVC9YS0ttbnExeVNUMFU3UGo0?=
 =?utf-8?B?b0pWdGZvSTR1Zi9oWUo1SVN0eHNFMFR2d3RYYWhjbUhYR2ZaSDhuOEE3YjlC?=
 =?utf-8?B?YTBHZ2FCMWU5d20rNlJDQXB4bGhuOFR0UkZpZDdhL2FJa1J4V3V6WERBeTZ6?=
 =?utf-8?B?YklZTDdmMjN0bnNPalY1V1dVK2Z6QkhmSmVLeHl4SUNzLzAzQkRVWmdjNHFL?=
 =?utf-8?B?S0tIemNVWk5Eejh4Vk1iSm1SNndJM21Ub2xVVkFneUZ0enc5T0hVeHhod1B4?=
 =?utf-8?B?WkZpRTJGZTU4dHJ1TmVWZ0JRNmM2Z0pPSnh4RW5UT09mNUFQaUFXZ1hBRk5t?=
 =?utf-8?B?Ylc3eGplbVZhOGk4bG5JNjYvQ0VNMU5RbExFQUE0MWF1UHhvTGM5MUVoQzB4?=
 =?utf-8?B?ZnIyR3dnYVUydlY0YXhLbUU5MjJHZmZsQjhFd1VUcE9IMUtEZ0NmL2ZEVVJj?=
 =?utf-8?B?cjl2V09jbkJoWlZVdEhUU2VjUmVWZ1hQeWxZTXdCQ29GalZJVjR3dkFmLzlK?=
 =?utf-8?B?OVE0QjRaV2VISEUzbzV4OEc1NGlEYXNLVjVBVGUvQVMrS2VyYThJUldrR3Ux?=
 =?utf-8?B?R2VxTktPL0JtaTd6c2NZUDdZbmpKbm5XK01qQm9pVDlTN1ljOUNTYTZMNjlH?=
 =?utf-8?B?MmdZbE5UTUtxdWM3S3FwSmF1dEtxdTlISUVDNFZTalBWRklSclBGeHhrbmxL?=
 =?utf-8?B?MmhOV1pqV3g4VS9uVjF5N0QvbVRPUUpZWkpoeHNuaWVmUUx0Wlh4cHpWbGdH?=
 =?utf-8?B?N050ZUxGR0YvSHdzTEttWHdsdnd5ZHdXby9SK2d2bE1aTW5kZUFqbjdCM2wr?=
 =?utf-8?B?Rkpuck5wMVhqVHgyVHdpN3d6NWo2SVQyeXAzenNCOFliRWQ1ZmE2elo1bWkv?=
 =?utf-8?B?VGoycC9JQ21uczdieVJML0d2Y2x4UnBDbDZMb0IxVDZnWmVaS1ZQUFdFRGJn?=
 =?utf-8?B?emRpK3YzOTdRRE1pakYrYksyZzVralNFczd3SmsyZm9Fa0Y2YlRDZ211RXBi?=
 =?utf-8?B?ZmZrUDRNaUJGRmEwUkFXbjVIOW5tT3dldkFPV2pXOGNGT0hiVGlwcXpmSWEw?=
 =?utf-8?B?YlgrcTJHcys3d3N1RmpkY09vN3dLWFowTm4vRDBRTWtOanowZGs0VDcwMEVF?=
 =?utf-8?B?T3JTNklLeVdnK0FJaGF3a1FqVXZYcmJpdytES1hqeVUreUVLOXR5dXB1bmk4?=
 =?utf-8?B?akNMQ3dGamNvZFlGd3lPWG0vVSt6Wk5tc2FPWjg0RXhlYk1NcGd4NmlNY0cw?=
 =?utf-8?B?YzUwRVFwSVVpVFQ4bnUvYXhzZGpHQVI4dGY5YTFuZ01SdG5hV051bWlFQ29u?=
 =?utf-8?B?OUdubUtYNkVvZTdqWXkrRVB4Q2J5cXFiL0ZyRWswWUdDMkJPbTY3N0VlejdL?=
 =?utf-8?B?OFlWLys5RTg2NkJyZUNnbDh5aDJIMWZ2TElQMkRCb1lKQTl2OXpOUEJGdEZq?=
 =?utf-8?B?dGVlMDhuMFlDSXVZdjBGelNlTGNCb1Y2akU1MjlrYmI3akp0cTNDY0Z5bW5y?=
 =?utf-8?B?M01sL1hmekdFOXF4R2krYkVrUU0zL1JHWGRiQlRTNmFRWU12UVB6d3piYzJM?=
 =?utf-8?Q?54vp//spv2N8uNZg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AC08EC06FA28B43A522A1B654D37A98@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69e6288-764e-456a-6631-08da17ea0995
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:25:17.5981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4GvzuKuP8ypM0k8f8ythGutz/HEUIpjW6QTgcXilQNpNV90L5nGzEFdUJpWPaS/hvdoJdWres/hZo0pglhlikQ==
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

T24gNC81LzIyIDIzOjEyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gUmVtb3ZlIHBzY3Np
X2dldF9iaW8gYW5kIHNpbXBsaWZ5IHRoZSBjb2RlIGZsb3cgaW4gdGhlIG9ubHkgY2FsbGVyLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IEFj
a2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0K
PiAtLS0NCj4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJu
aSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
