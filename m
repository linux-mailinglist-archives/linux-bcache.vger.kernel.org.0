Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00CB4F686F
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 19:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbiDFRsN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 13:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbiDFRr6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 13:47:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18221587B4;
        Wed,  6 Apr 2022 09:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR2IqTGa7tLIxjKroJZj8ednyMS88SV90X6rr/erv8Lq8gU19uGkC2hMi6TtFnAGY+c63XaHEnRbiFtiG+uFQ51vl0HqSQNM1Qr09T2wW4hdalPRLyE0F2IWYrkF1CQkZ6n6MMhv5vhp+tblyi109QUlq+g6dCjKmNIjQo7FFcOJmDoouYUb/pMYRqqlvVaYiiFkBYpEcK3lsRWpj4174P2CDxm84m2Of4SWBKxr03EPGx+pWROc4FsjEr3NBLuq6GqQ0KkcDza+mn+GnYHimlcyNh3hHwUYW0GrllAo99iJqD+6Obx0tYwfybCw7dYf8DLGtZF2aTRl4cpP4xOOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJAukSAYH13slROZ+O/1zE9dApu5nnkLcOe6ijXVn9E=;
 b=ZW2G2cby8F4bwAQbzQIqaN3qVfIhBfMlp/TJ9kAD/BMRj2UfuIztoBxJ+rOoHJotVshh8kWHK6qGLVnGBsAjo6QqVPWGY2sS5fyhpaipHmJh7fqMhhkWYY+ECVGVHr882H7CfhId6o5YhuqnXXFbxlYdLq9NKZC7G4W1pjQiAz19g1U3ufXPfR9rVdtQq46FmFTdO6xHaYbOI2wzh2YLnHCzY76KgyWhHJmTbCawDP3XSNdn4xW9its+zwfnB3aaOlEYnmOFj5LaoKZhzQJymFH4eqnGcEOJxWAPgBlDtNbWBMUAPXjYvsaEgU/X7v7DcJYUY22PrHF4JAEgbs39KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJAukSAYH13slROZ+O/1zE9dApu5nnkLcOe6ijXVn9E=;
 b=uZGdQ1fqOvJxNfw/y4aA0uzW8eTrHQ+6XwN5Mepb+77kUSowJ8anMOz2R419IiMRz7Ed4GE88OdV02vvFURm6XviQObg/6uhmJvvFmICne+g3wvxR25KXNeq7SuTQ4pCJUsdoxGpe1CvHLM+6tDMhoW0Yv8VVe3Dug7sWOKiBSlBQeMICRnMnvSCJPAgfY4je+MDUdfml4RS93SDXsLiMhPBsitAqdbRLsy5mrDSbl43lMZb2IPI/nk/e/9BUCjGef4YJYABjVHbh+OUjeYSqVOaBNtq5dMlMOCuxv4GuaOwEjeuqz9dJaCGxkhAgifhkslCK1KEvNnFtrvJVPvwfg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 16:23:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:23:39 +0000
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
Thread-Index: AQHYSZjZVpHjFA1osUGKQf+OEuELhqzjEiaA
Date:   Wed, 6 Apr 2022 16:23:39 +0000
Message-ID: <a3645fe5-21dc-d760-78a6-8912790c7828@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-2-hch@lst.de>
In-Reply-To: <20220406061228.410163-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a077090-1ee1-445f-245d-08da17e9cf23
x-ms-traffictypediagnostic: SJ0PR12MB5439:EE_
x-microsoft-antispam-prvs: <SJ0PR12MB5439A2189937CA836D0C0F5EA3E79@SJ0PR12MB5439.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SZako8/mNslluddmggn13XiHPs5LPJC57/JoMOCEAGuXb9TgWeAINll8jXP4sAx5tnUrGuzHDgr9P7PsCFU7iIWA7DsVFod3qefWuMAOqYYui7iP7PLtY41K1UIkDBNNmXQX1Wr2l9D+X850Sv4UE+riPXFnv3MZBBnjwK2+MxtEMVkr/js50fLJx96eAJgE+WPsFr6oaqWYiyMjpUbnJARBl3dE2CYFBZVRJ+Lax4zNRD0jiJ8q/Kp32i039lrxJuXGTvk7rAF1W6JUyeUBaLFcEXS8ohoDDVr4fOi/GPbplEOkoJBqAPKT00VJnJrWC+nnPSM1M9hXYmVw4pzMh9n5tVbb5I3yz3xrewIeq/EBqIcKhtFA805YAjUO2HpSzBEVZmu0hi4TDIV0P8VOyeiwhiMTItbk/GE/d/5bXxEsBgkUPxJnwC7yNVKtBrIIRLpJ4A1SaDmyxUYDwa2eh0/irmrYInUrNOqGvl6yGBUxePvcjVap67wcW7/XKGLqohMaZerlPz6Yob2UG8YtLI7rz4z2hIA3hAAqIrFmrfDBAX0ZZwtRTaPs7nhLy5S/HpVYAOcVgDxmMWMsbA5eg/NtSoQppBICjsgwsDMHB5xhuo45dr1SfT3/OzdhrVrAh1Pzs0auELk3rOkBTqZD2m4ZaeZntsYbjIK/A32SlLZSAb1VrEe8Y42G6jDIcW19N6Em/7iXxuWEQns/RG8gaxD17JwLdCfc6ie2a1L5gpzH4iBPwNrogfLDdG09oKCvM53RPLSdHlt2HTZqidBY/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(64756008)(66446008)(38100700002)(122000001)(91956017)(110136005)(54906003)(66476007)(2616005)(186003)(66946007)(316002)(508600001)(76116006)(8676002)(66556008)(6486002)(4326008)(53546011)(6512007)(6506007)(5660300002)(8936002)(2906002)(31686004)(71200400001)(36756003)(86362001)(7416002)(31696002)(558084003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUdqZ2hnZFZoQ3h4UjdSWlVYSjREZTUySlNtVnVQUzFjVWxIY2NwaEdDVGR3?=
 =?utf-8?B?RTd6RDNyNUlVcG5wRVlvM2ZxdnBZOU9teDdndi96bDEycWtxU0Z0dVJKUTAw?=
 =?utf-8?B?UUhFekNPSE5kN3B4RzhrdWFVdWNtTHlzRWs5cmNkL3lrV0lualFud2liWkdj?=
 =?utf-8?B?byszWE8yd1NxSy8vZDVUYWc5SUp5eDMyNnA5eFE3YWsyS2JmUElFZzRHbnBZ?=
 =?utf-8?B?elc2NW1UUWVDUlhjemhacXV2bWQ0Nkp5andFY1gzSkh0WlQzU2NIaEp0T2Nm?=
 =?utf-8?B?d2lQdlFVZ2l5QkcrZ29XSi9RSitnMWdHdlVxZkhxR291VDRnbWozWWJObjlX?=
 =?utf-8?B?TlZMVGJrQVlscU84d0FRdE9paDFuejRSdTUxRWRmRGRabkNUUzZ2ZFBCdHhR?=
 =?utf-8?B?ejdwRHZIU3hoRENPWmFSYkEyTitIM1N6WDAvdG5sRlV6RE9TaHYyZzNsZFRL?=
 =?utf-8?B?ZkdyK3Z2TU9nekxNUW1uMW00aG9SNCtwRGI3Q2dGUWNDUkZoYnU2VUFFTFo3?=
 =?utf-8?B?QjRNS3QrRFNOVnh4cFBVblFma0ZEdjdETGRady9ZQmxkVHNmSi92b0F3VzNX?=
 =?utf-8?B?bjlOODllWGZ2NEJkenp2ajU2eGF6ZklnaHk2WktsMGkyWE56VGtsam5pZDc5?=
 =?utf-8?B?Y0QvSEVnZ3J2RFVDcU9tdnhZM3Q0YjRDYzdVRXlTNnR1Zkp6eThqTXlVd3F1?=
 =?utf-8?B?TzdMTlJTZWlkc1djQmI2VE5UVk1NR1pQRW5xKzFteFdRdUErZmJ0YmFSL1Nr?=
 =?utf-8?B?MFREN0F4QWFPVGI4WW9KSGdDNndKa3dPMzdycUFMNjI1UWlNdVJmdEJpaWl0?=
 =?utf-8?B?RUg0clZSbGNJT3BiaXdSOHJzUnRmL2pXSEJvQ2dhSHpZSmxST3FSUnN3YitY?=
 =?utf-8?B?NUFaR0JjZmV3UjBlQi9oMnlubEFWdC9yS3YvcVR5ZEpjR01rS2JMRXdnVEl1?=
 =?utf-8?B?S25KR00xcTJjQlYwT0VHeFo3V2lBTnFFNFJlSFUrU3F2M3dTamVHMW9BRHZW?=
 =?utf-8?B?TlBIWHVsMTRVT2pWN241SmhiVFB1NTFPNmFLLytWOGFyOGtnZTJKWDFMaUxB?=
 =?utf-8?B?U2czdWtVOUVLeU5jeVhueE5WSEswQjdRU0dDWGVCc2o0SloxL2xzRnc3U1lp?=
 =?utf-8?B?Q3VkdHpSZW1QZ3kxMUhMMzd6Yk5rUCtuMGlETnpoczJHWmhtWUhPbHFZUjRK?=
 =?utf-8?B?SVJLNVBXTmVkUitEdHYrVU51S1dLMVB6YUZFMWwwY3U1UktaQXoxallIekxC?=
 =?utf-8?B?eEFXc3grY3c4MTJtWFJCcTNxSU1HOVQ2dDVIK2kvT29KRXRQeU51Z2xhbDRs?=
 =?utf-8?B?VGZCZ3hMZVBnZEhQMnJIYUtBRzFyMUNuNm1IRlRlaUp2RU9FcEJoZVJwQzZS?=
 =?utf-8?B?eWRLMFlXQkxKekxVTEEzZVZEMnEweStialQ5emNsbitXYVROckVaRWIxelBY?=
 =?utf-8?B?aDZ6K1hHOFFGR0YzTXFIOXJwVWRVR0lUeFBmVlN2QUE3SThkcGxxaHpadWdS?=
 =?utf-8?B?L3lPa0NHWWI0NWxSZFFTOSs4RHJiN2VuRERFajQyQWl2aHpMcndaKytaYmlE?=
 =?utf-8?B?SUtuTmVlSEdGRjEzaUM4Q2RqRkZuU3p6TVk5STl2TnZSL0lzSGNsbEczcFFp?=
 =?utf-8?B?WGVuMGZEQ1dKM016emNTT29DWWFSUjcxSERDc2JNMnZ2SDlYbFlIc2VNTi9w?=
 =?utf-8?B?Wk1rRVc0aGJNVk5lYVpaV0YzdGt1cFNPbDJPMTltY2gya3ExSzI5SmZSZzl3?=
 =?utf-8?B?dCt3eFc2Y1JBbmEwOUNEdndzak9Pdkw1dUl4SWJidnRzbTdnejB0VHJiUVdz?=
 =?utf-8?B?QkZoWUF4MzkrbDQ3czlxRS9nUFE0QWN2Q3JhbFBUdTBkUU9ISnArTVNjOWd2?=
 =?utf-8?B?eEJBc2pNRE5RWEduZ0ZJRU9SZmtCUGxMcXlVNlg4Qit4RWMvSzZ1TSt4YjJR?=
 =?utf-8?B?MmpraXZGNmd0VjVlamZyTnNrSGJOeDQwSUg2aGtqUncySnNOWXg2VGs0ODMr?=
 =?utf-8?B?am5WekFHdFlqQW1PRkNWR1huWklmcWJWMzJLcWdOL1VLUXRLem5sSHJHeDE0?=
 =?utf-8?B?Zk9jU0cwdmc0RHBMYXhnS3pId241bkpwRmlKc3lxRm9NVXUvQVIxTGEwck9w?=
 =?utf-8?B?QzZGS2pySnRac3B5VVA3RDRlUzE2WUJ5NlFESTl3RXJMOVpWYWZ2MlBjWEVN?=
 =?utf-8?B?MldtdmkvWWFGVnlLWW5xak5JNm1QYTJtQTh2YXV6bHp1SVVoVmRQNDd0clBS?=
 =?utf-8?B?UE1PSDlxSVVuTjc5NGdveUo2ZHpJUXFKZ1dLY1pHVld0N3FTVlY4eU5tM0JP?=
 =?utf-8?B?Z2V2cWNRa014Qkk2ZW5HSXF3SGJwa3d6R2JPQjdtNmd0cVFmQ05hMlQ2RVY5?=
 =?utf-8?Q?YBBXNd5EoECmn1rE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22D6CBC02F6B4148A8B02D35A022C69E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a077090-1ee1-445f-245d-08da17e9cf23
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:23:39.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXy1KvXEfF7i6rI3z61vddubR/PXNLrZpVU82Kdjaf7qwVfTyNNRX6cwDhygJebB9kR4F7gregyX2gmHXc8tnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gNC81LzIyIDIzOjEyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gVXNlIGFuZCBlbWJl
ZGRlZCBiaW9zIHRoYXQgaXMgaW5pdGlhbGl6ZWQgd2hlbiB1c2VkIGluc3RlYWQgb2YNCj4gYmlv
X2ttYWxsb2MgcGx1cyBiaW9fcmVzZXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IERhdmlkIFN0ZXJiYSA8ZHN0ZXJi
YUBzdXNlLmNvbT4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxr
YXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
