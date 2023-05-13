Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAA7013A9
	for <lists+linux-bcache@lfdr.de>; Sat, 13 May 2023 03:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbjEMBJU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 May 2023 21:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbjEMBJQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 May 2023 21:09:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CACB59F9;
        Fri, 12 May 2023 18:09:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moOHlzgkSFFdeN/by54UrBm/GumJ640l15vTZpffYJtjKGAYvJxkOlYMOZ0tqsrJYrQyynwDQttOcjTR8n61hOZmX9lNjaRrIq13CXs7B/dJc0IqkiR9KnEprje/3Ru1RH3k01F7eTTcmxo2VVqFfUHJe+SuP7xE5RF+hJ9XzwQtGrpEeVtdtcYkH7dVIENZfeq7KnpAIBg6a4oLhlwAjEfsez1w2maTPo7Br1jIYAc5Yq0CDz+VJsyt1Kd72XIOn+ByK6D6Z29KcNsc6wcTCUaWeb5Xb4mJ2ZTIWgrURiNniyXyAe0vRf+HyjAPa4sPdnygmbKS6JKcV7/he7/JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFNd/JYMdRcyAwNJX8eyJpCPQct8JJUMy12Y5dQxrhs=;
 b=Wp9lcLNnF0WRGxcpN3c284FCtFxQhE2KCkcyCzS7WFWrjJZbSEn2IwRMPAKht4PDtuuZeO8ZZ+La+5wiP2qt4HjZXiIhoc9mvw0twTgfsqm8NLTA9vXJinkA/8XBkW4IgjwW05L8V5c/tKuSw2n86pogSwAQhh8+KRNR88B41UYnfYVWBD4/neTjiSQuGhzjGRALqUCSCfanzXp5odFnOso5Fii1MgvAWLcUJkHegZPfBfM3uOJc8ox08sehKStgprKv5FsiL5FUI07ynnkarDTXueUrt1E9/qc8QNZStz1kxotsMG1g0S4xAO43uoboO85aWlygnNarqxasYKoIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFNd/JYMdRcyAwNJX8eyJpCPQct8JJUMy12Y5dQxrhs=;
 b=TFRW9i+T+wXD2XFX9zSCvritR47Dd3X6O33Gxfw50DjO9xRKcTgzstCg4yDQoOPzd/7r/fApoitWBIq14UDgaHLK4vTKntCtdt52HvWQQiFnsCALuwur9QqNOj5/Uz0FFuFgBaL+7JTcqPXC5gBhvR4/Dn8tJpTfTO5r67No8whQrmUeXZcrv9vjAVfL423zr2umytLeeOFby1LbyPLH+YrVQ8Qas0bqrnUhzfXAzN7fo1LsJtHrr/vDDmEtw855mAou+57XFK0CkEUVu6VB0iRefk5Wq/fzQbF8Vvneo24n5B6FbkgVchyLqR+Z3sTYDQeBkbsPuAchZJVgic+0Ow==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB5044.namprd12.prod.outlook.com (2603:10b6:610:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Sat, 13 May
 2023 01:09:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 01:09:11 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] block: add meaningful macro for flush op flags
Thread-Topic: [RFC PATCH] block: add meaningful macro for flush op flags
Thread-Index: AQHZhKjuJTefUUOpAkGElu0wVddDH69WmjEAgADLioA=
Date:   Sat, 13 May 2023 01:09:11 +0000
Message-ID: <67376534-ac4a-3cd9-fab6-fd3a062f5e48@nvidia.com>
References: <20230512080757.387523-1-kch@nvidia.com>
 <20230512130042.GA29078@lst.de>
In-Reply-To: <20230512130042.GA29078@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH0PR12MB5044:EE_
x-ms-office365-filtering-correlation-id: 06da0f20-0d2f-4f15-7a7f-08db534ea945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SBzOp/GJtiU8F85vDkiTc3zfq/tTiPy23x8C1FOZ9Ir5TDxsoT4TwPd452NoA9vWLVgCvw/a5bKUiUqrP9QErPswf/urJLihOj/iqYKWbiMDRggJ5opVW39ntJkhtwbmFYCi7/4QoYwWSNXwQvqfbOpINxUVMAFUVOuOFRbfbPIHbUs/5rqSTF/gPj6as01mQMMo2earDejFo5henVkktUgw/0IFrTztz6sO5L4aa853+faEf/Pb/NhTOnH3ITpqizcARF94ZP14MKHeOaTJurlOgVL14J7NvgPD11YXxHbmDJpZ+7PWTFaq3PkHQ24A32SxEtXgu+58RmbHjO9KRZ2xt+rh+FeG5P07i1JT0Pbd/32YZph+br2jyTMf+36zKTddsXCmLNsFcj4E9lZSf8NT4NpDlOrEgY9JsOXvWoBoyNQTlsM+vyxIgy3SOcJCwGsF8mOLvRRFlR8v7Wy+EEflEnbfTrWud/6Y87yFg29vJAZQGqrOfURvMI+PY8WSo+2ZtOV/6OTC8W4rxCrL3rDnPl1lC1fY7VjE8rPWXkYHEQ1J8WOextj0GCO72BSR9YXBNZuBkm9xxpGsPSTuuyf/m4FZ0KGFKURRjghTjmeBi3QtbIKW7jB9fXHD9C8tdTLyVSittuHDj8QePrturKKaeBsaJQAcmgMQ1crNSOGt32chrt1MbEz4Hl70zz8j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199021)(6486002)(38100700002)(38070700005)(4326008)(122000001)(53546011)(6512007)(6506007)(2616005)(186003)(4744005)(2906002)(8676002)(5660300002)(8936002)(7416002)(478600001)(36756003)(54906003)(110136005)(31696002)(41300700001)(71200400001)(316002)(66476007)(86362001)(66446008)(76116006)(66556008)(66946007)(64756008)(91956017)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk5oRnFrbTBWMmhSTjB0WjFhYnViZTM5eG9nY1ZhejVwZ1cwNVBTbmoxZ1R0?=
 =?utf-8?B?MHJkTW43TkxVSnpwc0I5Slh2Mi9XYnRlUVZyTDMxZEs0aDY5NkxtSnVNckVQ?=
 =?utf-8?B?cUFoN285V2o1blV6cTFBY2lhNWphbFdzNDNwclhyQ3dDRTR3OGRZUE56TXZC?=
 =?utf-8?B?ZmprcEE4ZFlnWFFLbWhWeUVBS2c2TE10VzBLV1RaUXpYTnRZRDZMZGVTMTEw?=
 =?utf-8?B?U21xV3hyWUkrRjQ1Q3FqNkVTeDN1NTBrNHd2OFhsKzJTNU55bzIxUnJnN2E4?=
 =?utf-8?B?TG43VU1qUXRQNHJPTVJiK2ZGamkxTWprNGluRWZZTy96bVdLYkcxaEwzY01K?=
 =?utf-8?B?R283Q3BXZUx0QTBiOXRsZlZ6cjFYYkhqdERMemdLRTVqR0tkaXl6cUlrUmd1?=
 =?utf-8?B?UDNkRW1QTlU5Y2tyUFBiSXc2aG13YTR0UjhEZE91QSthM2JCK2hyQVViY0Vj?=
 =?utf-8?B?eXczdUQ5MUZDb2Vuby81NVFNQzZrYThMVnY2bEtpSjVJZnlTam9qWmhwYzhO?=
 =?utf-8?B?VUFkTlNhZWJyaUN3TXBoSUowekQrQ2JISG9SVTRnSXJDRzlsRWVPd1JDOXNl?=
 =?utf-8?B?RUZZeC9ZTHZ3ejFvOXI5cjAwZFY4TW9heEx6aE1JRmkvQU1tUk1BTzU0SFpZ?=
 =?utf-8?B?cVBMN2d2Qlc0K1VaU2Q2Q1J4OXZReU1HaXVnd2V1dHA2ZVo2MmFXbGt4TzB3?=
 =?utf-8?B?bkRPT0h5ci94MzJiQWdpZEJ2L1dpNnRzemMzNngvNHJTL2hUdTFBS3p4N0lD?=
 =?utf-8?B?SjFJSzJUSENjd3pCejhpUUNndHJybmhMVS9LaFdraUl1UG0zV2I4SHhpbzN3?=
 =?utf-8?B?d1AzRFNrdGNaS2RqdGxlWVRJQmFBYitQQURmMlBIYUI2eEFac2Q5ODB3UXd1?=
 =?utf-8?B?Zk1lNEVBTE5sbjNnemtYcW5uYmk5VG9mSUE5ODl5N1VSQ3M4WXZIUDNpNlI0?=
 =?utf-8?B?Q3NVSWJKaHZFaldpMzg0dE1SWTZZbDhVVVJpTmpEeEJ4cEFSbXR6U1BiVjV0?=
 =?utf-8?B?Um5CUjZiTWFoWFVSWWYrMEc5Rlo2YlZBa01WRlFGb055dCtxOVduNXV1YUo4?=
 =?utf-8?B?NEZuMEtFZmJ2cHNOdHhLV1BMODYvcUlxSHpUU1RTbkY3U0hvUTBveE9kd3or?=
 =?utf-8?B?c0ZNOW9KbFJFUm15QkdweXN3akFkS0U3YjdnbC91RkdBUE9yRjFHemMwRFR3?=
 =?utf-8?B?MFdrOW5udUdaeWZiUTB3bUxReFRleW5icnRGT001OXYvN0pPRmtvWU4rT3hY?=
 =?utf-8?B?TU9uVTdnVFNLYTVFOExRanVrTW16c3Y2K1gySmNsS0Z0bXJFRHVCR21PTXFl?=
 =?utf-8?B?S2IxTGdreHpnaE9hTU0xSkxMRGgyd2ZUaE1IRXluTGI3dUNTRWc5bkM3ZVhG?=
 =?utf-8?B?UjBGVFgrZzZyVHlMcXpvSy8wVldoWTBQVEs3RnM4cEovQkIveXZUZTJTQ2NF?=
 =?utf-8?B?YnZURjN4U0k2RmN2TFFSUDVyNmhNRUlLdkxXOGFXNTBZU2lIMWhWeUJ1M3Vs?=
 =?utf-8?B?UXFUSzVhYXJwRC9JWFFpaU9PU0tVNXpQV0FBcXhUeUZhQSsyVjVUOFMzWGdi?=
 =?utf-8?B?NDM0WjdyMjk5NlNHdWhPZVp2WTQxcVpQQ0dqWWhsSEJldnRRRnRTeWhpeHdo?=
 =?utf-8?B?L3ByKytJcDVZVW90VmdHMXR2K0JscTEvbDlFVlpNMDYvVHQ2WnQzN3F0WDk5?=
 =?utf-8?B?UWVDdGNHR0E1ekJWYTNaVDVVYldPRTY1TzlQOHJmU1JhbjZ5aUNhbFo1Z1Z0?=
 =?utf-8?B?QURIUGphUHJrZkFtRUZNbHlMb0dsUldGZDhjZkhvaERJaTZQSHBqR0JJaGVm?=
 =?utf-8?B?U012U3o1cTdzbGdndzJ2aGRMRE9vS25CSmg2OS96enJYT0Jud1o4Y2hGRkFs?=
 =?utf-8?B?d2dTU2J4clJHQmNhYWJBbzdpemVYbVhpQkZYZFEwTkNMKzZiTmNHR01WY0pH?=
 =?utf-8?B?VWt4Y0djYTRzVVlXTnl5aFFHNVRNMmFwWUlGYlFLbTQ3b3BCT2txWlpycXlN?=
 =?utf-8?B?cnZvTVF4bjBhM0RXWVpZdDcvRjZneHgzR3UvcVN0MTIwMWg5dXFXc1RzN3E5?=
 =?utf-8?B?TnNFbU5sWGlPSGx5ZU0wTVJuTTlRZmdPNjQ5TnZjcVdnWEFjbS9EbVprQm5S?=
 =?utf-8?B?Mk1OVEEvV1NLNEdTVG1SMzJvWnhsVEtvU0RlUXIzUGdXL3N3YVY1TDBaZFhl?=
 =?utf-8?Q?zEUBaCMSXwtzNzF2fFcxg5bkDA8QQQWU/vAJjsogeQux?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <750E4C657651274B839324D156D21A23@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06da0f20-0d2f-4f15-7a7f-08db534ea945
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 01:09:11.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImhtPkay8Jgpum5FOFmitrbma2hkPOo6moo2T9vA7u5WKSq62UDaliLIjjp6PCBiBOGKoVXZk3mg9eaqaTLbGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5044
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gNS8xMi8yMyAwNjowMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEhlbGwgbm8uICBU
aGlzIGlzIGp1c3Qgb2JzZnVjYXRpb24uICBXZSBjYW4gbG9vayBpbnRvIGFjdHVhbGx5IGV4cG9z
aW5nDQo+IFJFUV9PUF9GTFVTSCBhdCB0aGUgYmlvIGxldmVsLCBidXQgbm90IHNvbWV0aGluZyBs
aWtlIHRoaXMuDQo+DQoNCmFuZCB0aGF0J3Mgd2h5IEkgbWFkZSBpdCBSRkMsIHRoYW5rcyBmb3Ig
dGhlIGNhbiB5b3UgcGxlYXNlIGVsYWJvcmF0ZQ0Kb24gImV4cG9zaW5nIFJFUV9PUF9GTFVTSCBh
dCB0aGUgYmlvIGxldmVsIiA/DQoNCkknZCByZWFsbHkgbGlrZSB3b3JrIHRoYXQgLi4uDQoNCi1j
aw0KDQoNCg==
