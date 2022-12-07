Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF56464E6
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Dec 2022 00:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiLGXRR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 18:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLGXRP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 18:17:15 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D1188B5D;
        Wed,  7 Dec 2022 15:17:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g775WIVu59e5PT5s+zVnR2S1ko2+8owxLUP/DUJKr6T3jaCnIlp0uFdNfZbTSwb8jHTL5wsB+umQ5MZ4gG+Qlr9fS+xbupHFcdfUQriRBspp4leufVRLiBuH8BeKZiKRgUIopJZsnVbAgYI4bjxHMTboSyWfmGnjxYqs8HaPAP3y2kFr4mPJI3MPVX3z0r7vokXo50kEAneBgBVvY3gj1EXHihCQn6utax5qIQQdJy8daveAtN5yjVkuWXylQHd28BcYEylInQ6PQ/s0gJxTjFcxu01wZsCBSD58wssblTdK05m0p1GhM02p/SNyoz21eugLzbt/ecE20g81XpE9dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFOfNDV22eM2CkqWJt1qNtROkfHjW9pKCvleVrKr2ow=;
 b=XXWJ9yoZjdcW4BcX+XF18Le0VwgaZTVEybLRZtsaVgdnyHTRqRgU7lpE7ZIAeTwL3Lgv+z+2Hp2IuWRDrYi0iNDWNZNpjcVWjdQgwBB5NUXQRZaWPWy4jz7FUzrkMD1nAMV3YO/g5dTv3kLUQf34aCiYsMY3jp2UpLpkKslKdS1Mb9TXHAeXWmuQhTCpZDmPrUSLC+Kjx/XUZ9hlZJ1XU4rQRfKcSx5Lh5u2XtES2sDi/8msG2klNzmKfOQ+VmGKl9lth1fUBTxBEczKBtnxk3BOeR2Xv74gLnKKahLubAj+UJMsPsj0UMSSfWW8sI5w/luM6GUed4LgEijBnEdkJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFOfNDV22eM2CkqWJt1qNtROkfHjW9pKCvleVrKr2ow=;
 b=CIgL/9xBaVvs0AnPNA8ZifpFhve8Jo+z49Ec2IbeVbOL+8OHqkULhy5VFQVn4LJfzOV4e5eXn9qOs8o6hz2zuEjI5hG5S2ME8T1qiUYK1531hUh/DWPZXkrxq8GqjKfIYFnlyCx5NV55aVyVvU3nksj0GlLcQ/PIfBKN61EyEo9j+TpeiqbjAsA1oAWzeFN1/mz3Dk1q6xcRk+hjlPlcAiteH9ZTj6psaNYFuqyi3FPKQdYZRxPw4norubmERrXcwJvJsB4Urg1tJoq/tWGVhAE+0jpEH635rx+yRhGNONLJTsOBrkj91nTyrnTtwz+2W6PzaA5PPLbOLc1kzOJ5iA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS7PR12MB6335.namprd12.prod.outlook.com (2603:10b6:8:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 7 Dec
 2022 23:17:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:17:12 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
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
Thread-Index: AQHZCovJdMlm6wlSxk2x2f41eVikla5jDJCAgAACagA=
Date:   Wed, 7 Dec 2022 23:17:12 +0000
Message-ID: <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
In-Reply-To: <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS7PR12MB6335:EE_
x-ms-office365-filtering-correlation-id: d9a18e21-17fb-489e-9f1e-08dad8a92bf9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ww6BsunjukQCDW1+TBpL+UtANg1SBeM2hoYfRywKSkRYD8vQQ9Vb1CyNQrsrDFGzL7JtW3lNIeojZ60nd9ViU4DjuC6Y4DVkdFJV8lDvzIzlYa5iFvFeNHVHSdwCaHRgRV7nkKTVEDcFbrczIeburUrr30HQr6eJcSVGv332TeLWt0GTx7ZG8+7lVJAUsjEeNNaP6g7Mp68Taw9OFgmVxoBAyQKhH05sB45nozZapV1+5bL2N2hxnvnOK+u01TH9YVJr9jVpLrLqOEz8HdL6c32Y8y8gE3sxZXaQ191RMW/tZrix13WGo7joosjssiVmM7uWiKQW6WcUIXrQWObx0OXmRO80xKgL7zfXLhA8/1DtJaU8bfRKlGHYRr5nMeVHcQcjdQsnaN4jikw9pEgBv5/WIkPaV12uxYtN1evZx9jOyGcW9WXYwSG7ur54N3sseZm9akt/djkQMv974rDkOK9hDCdxXmyZJCQAzcB4O9ocl+WOxgshv0+m/fujpli5ewH52kV/0oPWTaZIRks05QE92IkGyaU2TIZyFDdQfclMJWY3WBtpcjq7BlZTzJ+WZvvwz1KD5nMyJpnAYsRpU4K6OFnimwv+2seY0bT0XVS97LKGtZlynGEhLfSVE63pNbGazgunNfU3QvvNggqEVSsJ94yqIZMFZ/dm9gTeKLrmJY4SN7RwvFcef0NhBIiUoz/BOu/up3QFVJWjFffIIeEB99bUa0zw2BNe5O0LoZzZFtwjQvJmEvT1OYzOatfsK9XcES6r+qfQELkXRtiJ7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(31686004)(2906002)(4326008)(8676002)(66476007)(478600001)(7416002)(66446008)(91956017)(41300700001)(36756003)(66556008)(8936002)(76116006)(66946007)(64756008)(110136005)(316002)(6486002)(54906003)(186003)(6512007)(53546011)(6506007)(2616005)(38100700002)(83380400001)(71200400001)(5660300002)(38070700005)(86362001)(122000001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3Q1NmZITGpmR3RGbWlnbDhHWTFadk1Pdkc4Q29hQ3ZMVFB3bWx1cEc2TWdW?=
 =?utf-8?B?NTR3RFFIZnVmZi9TdkpGM01BN1k5V09hRkZ1T1BxY0MvNnA1d0VXMHFmUUNa?=
 =?utf-8?B?b3N3M1pUK0NJcHZsNEgzV0llZElSckNXUUx4eGdPa1V1dEtIMlFablhoWXEr?=
 =?utf-8?B?RXdCdC9jZWFaUXRlNDh5S2JwZlJ0a05HclVGT2k4SmQ1Q2xubU5EQUVOT3Y3?=
 =?utf-8?B?elpNemNuVVdSbzdGRDU3KzIrMlRQNnFpRVF2QnJEMDk0WEtwUk9zVDNuWGxm?=
 =?utf-8?B?d05SNEdCZHdNVyt6eW1wOUE2Z1VReEdmRmZrbC80bWpoaERBTmVMcDlhOFdG?=
 =?utf-8?B?eG0yVEVuU280VXhjZU9vekRKbS8vaVNJbVJ6dVFCQkpVV3BnMVVBMEpHUnRn?=
 =?utf-8?B?VDhWUCt6Zk5tU05JNWhvbTNNYkZJaXZQaWhCa1dTemRzZld1RXpMRnNhSjFV?=
 =?utf-8?B?Zk9yRjBhUHZEazkzUHh2NXVkWVd4R2tJWFRBRnBvUi9CZXE2Y2toaDREelNH?=
 =?utf-8?B?UlByb1pOYzBGS2QyMGp3V052eTNjZ1M2QXZrY1lheG1id0pzYkJQaWQrR2dX?=
 =?utf-8?B?aVR2dUtXNzdQM0Q0Y1hWeS9xQlJOdVlDbzJHS2F2VmlyNERXU1E3M0tlRU9T?=
 =?utf-8?B?cFIrTHZlUExxdDl3Z3J3b0c0dzJkeENXeHMyY2VKSk1qNUN4eGFKTEJBVFpq?=
 =?utf-8?B?RmxOTDRCUVRBakkwWnNrK2NvN1ZEajE3d1ZnVHA5NUNwd012TCtwVzR0SWl0?=
 =?utf-8?B?ajJIVkl2TGROL0xUNVdaVGp3QjJRV1F5OGFTbVZEd2JHUzd6RnhVKzl4bndT?=
 =?utf-8?B?TXJyTThhaUhIaUVKUmpBeDVoQm9QKzlyYnFYREVURTRXb2pnMTUyZFFmUnF6?=
 =?utf-8?B?Zkd6TnMxMC95UC9KL3BHYlRVMm41T05VNUJRM3dpVWVZMlZpcHFyb2F3MmRa?=
 =?utf-8?B?eEQ2VXNpZjBodjY3b3FaR0tMT1BBTi9laFpoVlcyZDc1TnR2SlpTMXlYNG1z?=
 =?utf-8?B?UUF5a0FxcTRIYzhyVkNxTnptZjh4MXJiQzN2dS9KaHRlWTI5REVVdUo3QUdx?=
 =?utf-8?B?U2tYSmVpZTVDeHVCTFNJRHhYdlFjY010TEVqandvOGcrOXArZXBoNTk5bmJ4?=
 =?utf-8?B?K0NjZHJLaGhvTmZkZGFzODFxYXRTODlaei9qa2g3K0ZwNnRDSXVlT1lYbGl1?=
 =?utf-8?B?QWk3S2lpd0Z1eVNZY0RVWktNeGcwR3RlWkdZdmsxblBMOWtjV01RQ3VhU2ZX?=
 =?utf-8?B?Nm1FaURJTGJsb0JtRm1rVTdDMVc3Yi9YQzZ2ZThBRHZnMTZ3WTVsOWJmc0pW?=
 =?utf-8?B?NXN3RjdQUU0vNnRZQ1BwM3I3TGdlSjVLWWZQZHE2a2h4TytOWVIvVkxzMTht?=
 =?utf-8?B?alhnMFNoeURKREppcmxVMXBHSTUxZG1XNFhSNXRZVWlnOEQ0d2NZdUdKdVBu?=
 =?utf-8?B?OS9PM0E5NU8wb2FabEMrNUFpNjhTMld0enZMSGpYc041MW11OG45VGxib25l?=
 =?utf-8?B?WTlqN0hBUjQ4RGhXM0lTK011bWt1dzRKZXp6R1VKdk1BUHZzaWFUdXhXNHps?=
 =?utf-8?B?Z2xEZk1JYjh1dTlhYXBBaFdKOTNFRjlRR1loYTRpZ1FGSkJTbVNYNjE2S3Nt?=
 =?utf-8?B?VGRselh4Mm9WSmhVUEtRbDRZSnZkNG9ubHRXNlJ4aFIyckFpUyt0dmtCWWRG?=
 =?utf-8?B?a0NUZWZPZ0N2dTVpMUwxaHVBU09OcG5YZEZuM21NaS9SQlUzdkVWSTRzaS9B?=
 =?utf-8?B?QzFJNnBISEtPRDNmWWxEYkZuYUZjMi8vV3ZGN3oyWkpDRyt3NEhzTHh3NFJL?=
 =?utf-8?B?ZGNZMzRkVWQreEtzcExRekdqWWZGU1k5MHArQ1gyT09zTHNQaVZqVmVBK1pl?=
 =?utf-8?B?cCtwakxkblFOdWVyekUveGVjRWNGZGllUTdLL2NHOVo0aW1iL2xTNHVFdFFC?=
 =?utf-8?B?djRXbFVsbUhrOURCS1YvOW5RcmhYbGM1MEg3NTZEemFGczgrR3BzYjV3WHA0?=
 =?utf-8?B?Z2d1dEdSVWtXVmJwM0tpNG9ZeFV0N3NSWWdTK2NJSytTUEJKU3Jaank4d0pO?=
 =?utf-8?B?YnlqT0lBSXVXZVhtbnJ4SjV2UXhxUUdmSW5rRStjckxvWTlyaHFvMDJqaXAw?=
 =?utf-8?B?cng5VlRaRFJROUJLb2lST01GUVhGSEs1OFVtTkVzc0cvZEZJM2dFTEdFdzJ5?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49B6173FD1ADDA4BAB931DDA7410A344@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a18e21-17fb-489e-9f1e-08dad8a92bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 23:17:12.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bHW7SWltXzhuPtJ6C+jJNKXOPFKDqIqyOvAynZqmyyZOkTzsSCV6nW0fSu8teNgq1FWktdDGmhmkaTtcq4WGEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6335
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gMTIvNy8yMiAxNTowOCwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gMTIvNy8yMiAzOjMyP1BN
LCBHdWxhbSBNb2hhbWVkIHdyb3RlOg0KPj4gQXMgcGVyIHRoZSByZXZpZXcgY29tbWVudCBmcm9t
IEplbnMgQXhib2UsIEkgYW0gcmUtc2VuZGluZyB0aGlzIHBhdGNoDQo+PiBhZ2FpbnN0ICJmb3It
Ni4yL2Jsb2NrIi4NCj4+DQo+Pg0KPj4gVXNlIGt0aW1lIHRvIGNoYW5nZSB0aGUgZ3JhbnVsYXJp
dHkgb2YgSU8gYWNjb3VudGluZyBpbiBibG9jayBsYXllciBmcm9tDQo+PiBtaWxsaS1zZWNvbmRz
IHRvIG5hbm8tc2Vjb25kcyB0byBnZXQgdGhlIHByb3BlciBsYXRlbmN5IHZhbHVlcyBmb3IgdGhl
DQo+PiBkZXZpY2VzIHdob3NlIGxhdGVuY3kgaXMgaW4gbWljcm8tc2Vjb25kcy4gQWZ0ZXIgY2hh
bmdpbmcgdGhlIGdyYW51bGFyaXR5DQo+PiB0byBuYW5vLXNlY29uZHMgdGhlIGlvc3RhdCBjb21t
YW5kLCB3aGljaCB3YXMgc2hvd2luZyBpbmNvcnJlY3QgdmFsdWVzIGZvcg0KPj4gJXV0aWwsIGlz
IG5vdyBzaG93aW5nIGNvcnJlY3QgdmFsdWVzLg0KPj4NCj4+IFdlIGRpZCBub3Qgd29yayBvbiB0
aGUgcGF0Y2ggdG8gZHJvcCB0aGUgbG9naWMgZm9yDQo+PiBTVEFUX1BSRUNJU0VfVElNRVNUQU1Q
UyB5ZXQuIFdpbGwgZG8gaXQgaWYgdGhpcyBwYXRjaCBpcyBvay4NCj4+DQo+PiBUaGUgaW9zdGF0
IGNvbW1hbmQgd2FzIHJ1biBhZnRlciBzdGFydGluZyB0aGUgZmlvIHdpdGggZm9sbG93aW5nIGNv
bW1hbmQNCj4+IG9uIGFuIE5WTUUgZGlzay4gRm9yIHRoZSBzYW1lIGZpbyBjb21tYW5kLCB0aGUg
aW9zdGF0ICV1dGlsIHdhcyBzaG93aW5nDQo+PiB+MTAwJSBmb3IgdGhlIGRpc2tzIHdob3NlIGxh
dGVuY2llcyBhcmUgaW4gdGhlIHJhbmdlIG9mIG1pY3Jvc2Vjb25kcy4NCj4+IFdpdGggdGhlIGtl
cm5lbCBjaGFuZ2VzIChncmFudWxhcml0eSB0byBuYW5vLXNlY29uZHMpLCB0aGUgJXV0aWwgd2Fz
DQo+PiBzaG93aW5nIGNvcnJlY3QgdmFsdWVzLiBGb2xsb3dpbmcgYXJlIHRoZSBkZXRhaWxzIG9m
IHRoZSB0ZXN0IGFuZCB0aGVpcg0KPj4gb3V0cHV0Og0KPiANCj4gTXkgZGVmYXVsdCBwZWFrIHRl
c3RpbmcgcnVucyBhdCAxMjJNIElPUFMuIFRoYXQncyBhbHNvIHRoZSBwZWFrIElPUFMgb2YNCj4g
dGhlIGRldmljZXMgY29tYmluZWQsIGFuZCB3aXRoIGlvc3RhdHMgZGlzYWJsZWQuIElmIEkgZW5h
YmxlZCBpb3N0YXRzLA0KPiB0aGVuIHRoZSBwZXJmb3JtYW5jZSBkcm9wcyB0byAxMTJNIElPUFMu
IEl0J3Mgbm8gbG9uZ2VyIGRldmljZSBsaW1pdGVkLA0KPiB0aGF0J3MgYSBkcm9wIG9mIGFib3V0
IDguMiUuDQo+IA0KDQpXb3csIGNsZWFybHkgbm90IGFjY2VwdGFibGUgdGhhdCdzIGV4YWN0bHkg
SSBhc2tlZCBmb3IgcGVyZg0KbnVtYmVycyA6KS4NCg0KLWNrDQoNCg==
