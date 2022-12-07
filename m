Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7570B6464B4
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Dec 2022 00:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiLGXDD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 18:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiLGXCs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 18:02:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0761663AC;
        Wed,  7 Dec 2022 15:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXtf3LosNpRmYc433CkH+62lBWlPZmGKwQZxw4eucLx7nRLlubYTSLn7enoaaHzmz+NiFhyhKVMXIKkDhsnpy/hTVhhp/xXkpjg/o0IPsKxyP3Whb/WA0otaUg0wAAD7WWCsgPvhPLQJVoXlO9ZFBELlrqhHWrNtB0kNRdDUeRt2QfMdQooOwS6zBCeZDIvLmzQ88vxXyn+Uer+q7adWKlc3pyRPm3W9GHn4NRO5gkjlspjusCAyWbeo1vjGKZqG18UQsfH3CoXKOnyVETJsLljpp8WUlsqEB4ZgOs5/44qYQoeFh+EMvgEkt8eZ6Fir+pPbLxE6cBvkZ1f7tdtQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yU2MZbtSFontsOQ90mzeDIx5A9xuOEYN03cWD1FMgyc=;
 b=KXA967uXknnbE+ROb7ph+F4gDHgxZCpUBrbvMHyR7jMHdjiSpMAYeAx59rfkG3JVXNGRZVMfWrVkw0MH2YWOdCGPW0Gmo8GT/6dUYwiy9yRLKG5vVTbroCJ84utiN7i+p9dKBw0wi3/v3U0WHSHKON4VnpLpaBLQJYEdu8XmocSSfZ3gw8scZtJT1YUMlK8QRCUFrZ4M3NUCdbOaq+5HPUuffKFbx/kwDPsI5pl7OGNIpuh+dWxcDL/QkYwCMm/qOpbLtaj/BvLJEyXm2rInK+u3dAjUjXMiw84LQECyHSWL6bxGLCPmiRa7UPtICEpe3KHpZOD2qlthDkCN4m/Wsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yU2MZbtSFontsOQ90mzeDIx5A9xuOEYN03cWD1FMgyc=;
 b=VQU0RskSzavTdFpr9fzOIGfmK4/FVNgboRk7fHlozOgY1YlJS60D6Jqkkxet5+6NrBR2GLBNnPibrkgI96Qi+vJ1Q0VAzE1GCOkVMNeoAMI75rPIkiJB3VIqpJmIomGJoWv0ino1Gj5Yc85ayv2YxbOf2ATya6dYJ8Z+XGugucBTKNYrNQ4V81mmH3WtyAmbdWKikmfNTVbpHI/c0SUxPWGF/n3E3W7cClpGRBMLXKwQ+uNWIuDsiNcdcs3UPlxpx7J0LiSUyEvUnmE75NE4jr5ysKohd7kQxcMeo5ikEVAZKzh2zHHqK3km/Hk22KOi+N2wD6Q2t6uY4hc6YyRHpQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:02:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:02:38 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
        "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
        "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>
Subject: Re: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Thread-Topic: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Thread-Index: AQHZCovJdMlm6wlSxk2x2f41eVikla5jCueA
Date:   Wed, 7 Dec 2022 23:02:38 +0000
Message-ID: <7a658866-c7b8-00de-ab82-4b8212cb2603@nvidia.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7015:EE_
x-ms-office365-filtering-correlation-id: 82626d82-52ec-47b9-fb02-08dad8a722cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kx5+1OsqY45gvH0ex7U3LuUgkAHs2ZhKM+1Pd5Fm+ljstY6hS3346YF1fsq00QXLdZYLUNJZwG6gaOB1k6uxJ3V+0iJvrI6GoFUtrF1LDgzMfOEHI7TFmFAZS7iNOrsR9YZmfQgBr0GJjNnvIBuGIL7qvxHSqdSAFcMXlDCfal1P1NJgAr4dy273iWZoE5uGRWvxZPVsVTVwhs5KEn92n14+WdUhvwrMsx6XNLqqMSkCyzVsBlyYLF3rRl0hSMk9eSYfPmXjXFP1bUXBXd6FpE+3Y0RqQIWfqigHTo25Wc1WzVxWANKuOXWTMrUXFmhoR13j++4U/QG+hWyeZBMBQlNj1x/t2vGlhC8IaMw5UNSpLRuc3yvjm+jXSU94VRnJGsA6eebIbAs4PoL0jbXXbvh7S/KzM4k5wSH13DAU/Qc/ZOiPYgUys87rjSzw7NPyjNJn4AxE9i5nZP4lMav5CxhA+H/W4mNmJwZoYnAtXgG9UYLuVyaSu954hWOfCLKM/AOKqT45FwOD8L6n/8kSkiCtv+dgyOAa1zKcJ886XkeW39TkouQzDsWyY0bpxCwRN4CMO9io6lEU5REpqoYsCrfsdELO7++rCsF/YvC1CkgLwzBZ7WKuNxmkpgh7DeM5u/b/rVLm71RbP0sZ3+C12oFby649Uy0rHNzcSqHStPNnhNGxGQRSZkj6oluyRI6Z2b/xIzV6mtC2YWOBrtyZxysW4q8WH0FwPGGB/jf8o53+DGJR4TA1G8qYjky6g+sq4JnWZQ0W+vhbsg7q7XIPcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(36756003)(31686004)(38100700002)(86362001)(31696002)(5660300002)(41300700001)(2906002)(4326008)(38070700005)(7416002)(8936002)(66556008)(83380400001)(122000001)(91956017)(478600001)(71200400001)(66946007)(66476007)(316002)(66446008)(6486002)(110136005)(76116006)(54906003)(2616005)(8676002)(6506007)(64756008)(186003)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzhlSWUwWUNzRnhHbE42TVdkdWd0azRUN2lmZ2YrcDB2S2dmdG1OeS84THlP?=
 =?utf-8?B?b0dvZ2xSOCtHUlQ1aVJ3a2kxRitISE5MR3JxZExEMjZLc1FEOGsxU1RUVjMy?=
 =?utf-8?B?Vmp1TW1NTmpLczQ3S241UEVCZ2N4UkhKREl6NjBYTi9Bak8wRVRZa2ZlNUs1?=
 =?utf-8?B?akFtb1VQU2hQbE1GWWFScnFVRmFjTCt1SzErVm5PUlQ3YjFBZkVEZm42Qk1V?=
 =?utf-8?B?STNXWm91d3RVTFVHYlJhdUdRSDZrbVZnZUsyRm9iUEFVV2w5dThQK2pUVmxL?=
 =?utf-8?B?bUdQYVFyL2YxUkJHUk00YTJPQS9Majk5T0pFdXY1em8rSnI3elhzdHppRnda?=
 =?utf-8?B?UFZ1U3gwL1ZzbE9laTkrREttUU55ekxnV2krUG5ZdGgvRWxYUW1IT1FFMVZ4?=
 =?utf-8?B?anZJMHl6SVZSdlF4NFJtNlR2MGhYUFkzbWo1RTlVZzJjMmpZRGxPUjJROFEy?=
 =?utf-8?B?UzBWVXhBMkRkZXVVTmRqa2ovSmVJaG1Ydnc3b3VKRk1RbVpLRzBHYlZ1L2g1?=
 =?utf-8?B?U0dBS20xUFlGRU03RVh2S2JjNm5ON0dWbkl4MFdPdXdwSDYvSGE4c0RUQnZk?=
 =?utf-8?B?UmFYdGtNK3BpWlRmQjJKL3JuOGdlbmJBNUR0QUkza2dyZVlWbzJCMEtyN3FM?=
 =?utf-8?B?SUFmSWh4QlM0ODZIR2FXRTZoZ0xaSXR1REI3czJ6N3M3cnlFZ0dYK0Z5Njlh?=
 =?utf-8?B?WldsRjRMRmRrQnMxcEd1VWE4a2FsQmY0d3lhaDhjeU5weDYyeFNJNXk0dXFP?=
 =?utf-8?B?SlNjdWFBUjhBanpjU2xPT2F5RjJZZU1qcVRCbjJKQm9zOG13RSs0SjJER1Fj?=
 =?utf-8?B?WjV0bmNFTHBMcUJ2OUtuNmp1bzZUWTBtMGRQeEhzZklrd01LVnBGazRXUnZT?=
 =?utf-8?B?cHNTQW9JeWhSNEhQTHNJVlpYRFdmVUZoSm9OQ2xESkpoSlVZaW5Hdlc3OCs5?=
 =?utf-8?B?cEZkS05oWlg4aHBuRHVLdXV6WG42WUZYYVpFb1l5ZXY3VUFQS3AyME5uSmZV?=
 =?utf-8?B?RkRyd3dxN1ZlanVtMFhhT1lzY1dRaFhHaG92ODhlVEtSUzNtbWQzRFlKWEdk?=
 =?utf-8?B?KzBqZWhwemExKzl0aGpMWmt4d2dRL1J0YzQ3aDFqbWZHOXVHUlBGcWpBc3Vm?=
 =?utf-8?B?VFVZL29sK0s4QmpoVlpxRUUxZWRnM3VrcjBpYzloUGZWNG9ZVlZxSlBvQlpp?=
 =?utf-8?B?WFBLRHVOdThhYkc1UlU0TDNJeUVvdFR5UmlYWFF5dyttNG16RXJyeC9hYkF4?=
 =?utf-8?B?UVZIbmF1a1hCWkNDSlVUOVFGVWFYZVAxdjFzaDc3bUJkZXFnQnBVMXFGbzVq?=
 =?utf-8?B?MTN4TGg2RlNZcDErMXUzMmdpMGxhYkZwR3hMOFBxQUZzMjRzNmR3dVErMXFa?=
 =?utf-8?B?akptMGx0Z0ZCdWcwTk1tRm4vY0xadURWTzd6bDkyQ0FXZ05OKy9GazN1ZDN6?=
 =?utf-8?B?Q2VWWmFBRVRtVDhWNloyYjhFL2VwNFE4VmlDYWdQODI0WmxsTy8yaGR3eXgv?=
 =?utf-8?B?bDBYclBFTU5iaHh3Sks2aWNmaWpWODhIaWxGczE5dHc3aG9LVzlPUUZhVVMz?=
 =?utf-8?B?VEF5Tjc4T2tGaXV2cGUyelJaTFhncmhNOGJoY2pRMVNVS1VwdDdlQmxacElw?=
 =?utf-8?B?Q2ZIUUkremdVWjZWWmhBZzkvVTd6K2lCYnZXeUFQenlZQUNCNDB2VUhxV3Js?=
 =?utf-8?B?UW1VbGNGZHd6UlZNTXVBeGlEV2c0aGtKV2Zwa0o0UVZXdVNJK3ZweVRvNmpF?=
 =?utf-8?B?d0RocXo4WUYrbzZDVFNBR3dUckIxeE1OL21XVFR5c0FmcTNpS25wR0liV3J6?=
 =?utf-8?B?SFdIa1pGUWE1eE9qSGdkV2drczltVzNrOEkzOFFpdmRYZ1hUSDlxdVRFbWxt?=
 =?utf-8?B?b3B1bkNWRU54bzEzS2szVEtOYndMd1dEOHFabS9wRnpDYnZJRXFUdHFoNDln?=
 =?utf-8?B?ZGoxMS9OaWdUTzMzUFFrWmRZQ2pYN3EzMmpsVUVuVUxSa3B6NGY3MjlaREQx?=
 =?utf-8?B?dmU1Z3VzSTJucm02Z1ExdXJqenVOM2RLenRpS1hwS3c1WWhwQUMvSUt5MGpn?=
 =?utf-8?B?TFNpb2FzU1g3VXlIN01xY1o3azRDaTNITHRTb1A3YXlXOXdCQklSMUxFRGo1?=
 =?utf-8?B?RmMvWDlISVJhSnYyckg2UzZKRmZickczMjRXc0dadG1kWWRsRHJyMFlrMktl?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80992709039F884A97659819F8B9D6A9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82626d82-52ec-47b9-fb02-08dad8a722cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 23:02:38.1031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QdC7Z8tZF3p1Ldr0onDPjaAi7EFmfLr/GZcBY2qVJwqBRxuHHxkxLM4rOQwAXTsobFQP8jhsCk4s5oeG+wxdZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gMTIvNy8yMiAxNDozMiwgR3VsYW0gTW9oYW1lZCB3cm90ZToNCj4gQXMgcGVyIHRoZSByZXZp
ZXcgY29tbWVudCBmcm9tIEplbnMgQXhib2UsIEkgYW0gcmUtc2VuZGluZyB0aGlzIHBhdGNoDQo+
IGFnYWluc3QgImZvci02LjIvYmxvY2siLg0KPiANCg0Kd2h5IGlzIHRoaXMgbWFya2VkIGFzIFJG
QyA/IGFyZSB5b3Ugd2FpdGluZyBmb3Igc29tZXRoaW5nIG1vcmUgdG8gZ2V0DQpyZXNvbHZlZCBz
byB0aGlzIGNhbiBiZSBtZXJnZWQgPw0KDQo+IA0KPiBVc2Uga3RpbWUgdG8gY2hhbmdlIHRoZSBn
cmFudWxhcml0eSBvZiBJTyBhY2NvdW50aW5nIGluIGJsb2NrIGxheWVyIGZyb20NCj4gbWlsbGkt
c2Vjb25kcyB0byBuYW5vLXNlY29uZHMgdG8gZ2V0IHRoZSBwcm9wZXIgbGF0ZW5jeSB2YWx1ZXMg
Zm9yIHRoZQ0KPiBkZXZpY2VzIHdob3NlIGxhdGVuY3kgaXMgaW4gbWljcm8tc2Vjb25kcy4gQWZ0
ZXIgY2hhbmdpbmcgdGhlIGdyYW51bGFyaXR5DQo+IHRvIG5hbm8tc2Vjb25kcyB0aGUgaW9zdGF0
IGNvbW1hbmQsIHdoaWNoIHdhcyBzaG93aW5nIGluY29ycmVjdCB2YWx1ZXMgZm9yDQo+ICV1dGls
LCBpcyBub3cgc2hvd2luZyBjb3JyZWN0IHZhbHVlcy4NCj4gDQo+IFdlIGRpZCBub3Qgd29yayBv
biB0aGUgcGF0Y2ggdG8gZHJvcCB0aGUgbG9naWMgZm9yDQo+IFNUQVRfUFJFQ0lTRV9USU1FU1RB
TVBTIHlldC4gV2lsbCBkbyBpdCBpZiB0aGlzIHBhdGNoIGlzIG9rLg0KPiANCj4gVGhlIGlvc3Rh
dCBjb21tYW5kIHdhcyBydW4gYWZ0ZXIgc3RhcnRpbmcgdGhlIGZpbyB3aXRoIGZvbGxvd2luZyBj
b21tYW5kDQo+IG9uIGFuIE5WTUUgZGlzay4gRm9yIHRoZSBzYW1lIGZpbyBjb21tYW5kLCB0aGUg
aW9zdGF0ICV1dGlsIHdhcyBzaG93aW5nDQo+IH4xMDAlIGZvciB0aGUgZGlza3Mgd2hvc2UgbGF0
ZW5jaWVzIGFyZSBpbiB0aGUgcmFuZ2Ugb2YgbWljcm9zZWNvbmRzLg0KPiBXaXRoIHRoZSBrZXJu
ZWwgY2hhbmdlcyAoZ3JhbnVsYXJpdHkgdG8gbmFuby1zZWNvbmRzKSwgdGhlICV1dGlsIHdhcw0K
PiBzaG93aW5nIGNvcnJlY3QgdmFsdWVzLiBGb2xsb3dpbmcgYXJlIHRoZSBkZXRhaWxzIG9mIHRo
ZSB0ZXN0IGFuZCB0aGVpcg0KPiBvdXRwdXQ6DQo+IA0KPiBmaW8gY29tbWFuZA0KPiAtLS0tLS0t
LS0tLQ0KPiBbZ2xvYmFsXQ0KPiBicz0xMjhLDQo+IGlvZGVwdGg9MQ0KPiBkaXJlY3Q9MQ0KPiBp
b2VuZ2luZT1saWJhaW8NCj4gZ3JvdXBfcmVwb3J0aW5nDQo+IHRpbWVfYmFzZWQNCj4gcnVudGlt
ZT05MA0KPiB0aGlua3RpbWU9MW1zDQo+IG51bWpvYnM9MQ0KPiBuYW1lPXJhdy13cml0ZQ0KPiBy
dz1yYW5kcncNCj4gaWdub3JlX2Vycm9yPUVJTzpFSU8NCj4gW2pvYjFdDQo+IGZpbGVuYW1lPS9k
ZXYvbnZtZTBuMQ0KPiANCj4gQ29ycmVjdCB2YWx1ZXMgYWZ0ZXIga2VybmVsIGNoYW5nZXM6DQo+
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiBpb3N0YXQgb3V0cHV0DQo+
IC0tLS0tLS0tLS0tLS0NCj4gaW9zdGF0IC1kIC9kZXYvbnZtZTBuMSAteCAxDQo+IA0KPiBEZXZp
Y2UgICAgICAgICAgICByX2F3YWl0IHdfYXdhaXQgYXF1LXN6IHJhcmVxLXN6IHdhcmVxLXN6ICBz
dmN0bSAgJXV0aWwNCj4gbnZtZTBuMSAgICAgICAgICAgICAgMC4wOCAgICAwLjA1ICAgMC4wNiAg
IDEyOC4wMCAgIDEyOC4wMCAgIDAuMDcgICA2LjUwDQo+IA0KPiBEZXZpY2UgICAgICAgICAgICBy
X2F3YWl0IHdfYXdhaXQgYXF1LXN6IHJhcmVxLXN6IHdhcmVxLXN6ICBzdmN0bSAgJXV0aWwNCj4g
bnZtZTBuMSAgICAgICAgICAgICAgMC4wOCAgICAwLjA2ICAgMC4wNiAgIDEyOC4wMCAgIDEyOC4w
MCAgIDAuMDcgICA2LjMwDQo+IA0KPiBEZXZpY2UgICAgICAgICAgICByX2F3YWl0IHdfYXdhaXQg
YXF1LXN6IHJhcmVxLXN6IHdhcmVxLXN6ICBzdmN0bSAgJXV0aWwNCj4gbnZtZTBuMSAgICAgICAg
ICAgICAgMC4wNiAgICAwLjA1ICAgMC4wNiAgIDEyOC4wMCAgIDEyOC4wMCAgIDAuMDYgICA1Ljcw
DQo+IA0KPiAgRnJvbSBmaW8NCj4gLS0tLS0tLS0NCj4gUmVhZCBMYXRlbmN5OiBjbGF0ICh1c2Vj
KTogbWluPTMyLCBtYXg9MjMzNSwgYXZnPTc5LjU0LCBzdGRldj0yOS45NQ0KPiBXcml0ZSBMYXRl
bmN5OiBjbGF0ICh1c2VjKTogbWluPTM4LCBtYXg9MTMwLCBhdmc9NTcuNzYsIHN0ZGV2PSAzLjI1
DQo+IA0KPiBWYWx1ZXMgYmVmb3JlIGtlcm5lbCBjaGFuZ2VzDQo+ID09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gaW9zdGF0IG91dHB1dA0KPiAtLS0tLS0tLS0tLS0tDQo+IA0KPiBpb3N0
YXQgLWQgL2Rldi9udm1lMG4xIC14IDENCj4gDQo+IERldmljZSAgICAgICAgICAgIHJfYXdhaXQg
d19hd2FpdCBhcXUtc3ogcmFyZXEtc3ogd2FyZXEtc3ogIHN2Y3RtICAldXRpbA0KPiBudm1lMG4x
ICAgICAgICAgICAgICAwLjA4ICAgIDAuMDYgICAwLjA2ICAgMTI4LjAwICAgMTI4LjAwICAgMS4w
NyAgOTcuNzANCj4gDQo+IERldmljZSAgICAgICAgICAgIHJfYXdhaXQgd19hd2FpdCBhcXUtc3og
cmFyZXEtc3ogd2FyZXEtc3ogIHN2Y3RtICAldXRpbA0KPiBudm1lMG4xICAgICAgICAgICAgICAw
LjA4ICAgIDAuMDYgICAwLjA2ICAgMTI4LjAwICAgMTI4LjAwICAgMS4wOCAgOTguODANCj4gDQo+
IERldmljZSAgICAgICAgICAgIHJfYXdhaXQgd19hd2FpdCBhcXUtc3ogcmFyZXEtc3ogd2FyZXEt
c3ogIHN2Y3RtICAldXRpbA0KPiBudm1lMG4xICAgICAgICAgICAgICAwLjA4ICAgIDAuMDUgICAw
LjA2ICAgMTI4LjAwICAgMTI4LjAwICAgMS4wNiAgOTcuMjANCj4gDQo+ICBGcm9tIGZpbw0KPiAt
LS0tLS0tLQ0KPiBSZWFkIExhdGVuY3k6IGNsYXQgKHVzZWMpOiBtaW49MzMsIG1heD00NjgsIGF2
Zz03OS41Niwgc3RkZXY9MjguMDQNCj4gV3JpdGUgTGF0ZW5jeTogY2xhdCAodXNlYyk6IG1pbj05
LCBtYXg9MTM5LCBhdmc9NTcuMTAsIHN0ZGV2PSAzLjc5DQo+IA0KPiBDaGFuZ2VzIGluIFYyOg0K
PiAxLiBDaGFuZ2VkIHRoZSB0cnlfY21weGNoZygpIHRvIHRyeV9jbXB4Y2hnNjQoKSBpbiBmdW5j
dGlvbg0KPiAgICAgdXBkYXRlX2lvX3RpY2tzKClhcyB0aGUgdmFsdWVzIGJlaW5nIGNvbXBhcmVk
IGFyZSB1NjQgd2hpY2ggd2FzIGdpdmluZw0KPiAgICAgYSBidWlsZCBlcnJvciBvbiBpMzg2IGFu
ZCBtaWNyb2JsYXplDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdWxhbSBNb2hhbWVkIDxndWxhbS5t
b2hhbWVkQG9yYWNsZS5jb20+DQo+IC0tLQ0KDQpJIGJlbGlldmUgaXQgaGFzIG5vIGVmZmVjdCBv
biB0aGUgb3ZlcmFsbCBwZXJmb3JtYW5jZSwgaWYgc28gSSdkDQpkb2N1bWVudCB0aGF0Lg0KDQpC
YXNlZCBvbiB0aGUgcXVhbnRpdGF0aXZlIGRhdGEgcHJlc2VudCBpbiB0aGUgY29tbWl0IGxvZyB0
aGlzDQpsb29rcyBnb29kIHRvIG1lLCBJIGJlbGlldmUgeW91IGRpZCBhdWRpdCBhbGwgZHJpdmVy
cyBhbmQgcGxhY2VzDQppbiB0aGUgYmxvY2sgbGF5ZXIuDQoNCkxvb2tzIGdvb2QuDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg==
