Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79E220838
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 11:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgGOJIu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 05:08:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60575 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgGOJIt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 05:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594804205; x=1626340205;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VF+54si5a3gx4CnM7I7wpw6AX577bV2AHq3fu2xrGpE=;
  b=HzBbHq3gpknzzfKAsk3Q20Pqy/BSAaMfFGI0ve+jEUimNuP3NUWHOC3w
   CZlWVIU1SCAa6BriUN+7ge/AMKIRPv93/IMF7N2Ahk7ZCJMqlTWlmRait
   T0+Bdm1/SITdEVhe+t8mbCTN+b7V6cDS/Ezn6FTEkVJZSirCCBM53yCnZ
   hF2tU+6kl4VasqV+OGg6zsLPkLnUcFVdKYVZ4SAo6kC9ud8SmiivhzaJm
   nBVE++VWPJ0wYNe6Wd7cU2OmFMGAWI8WT2QjFN6Rl8O20+2wnDl3XcCGE
   FW2FL1eXCEjeYT+mWOPHTGi3T7nmR2VAyitPAW0mpTTrd2mcks2myU11B
   A==;
IronPort-SDR: Na37PcFWMlgdfSVRE/jBr67Jydnqssr0tvoGLuOfDUlWkJEgQxaAGHuMgzBd4N8pNGf7HO1HJA
 6y1he3EvrWydAVATYuw1SmTQ60dTVB+soGbk3jVCwkgMaZElqu7mqji47z37IP2DkvElluXYXg
 kZ3ELb9N5zJvwz6f5Y3cjenWn2a4b6ILdf8cxPVF9dNXqTtIILK+g78P+7JuiGoNn9ceflobLU
 FZJ0IOwkcoLBUys8Yc0eZzbQ3YL4PnH7pOxcXgDZ1uWXokVb/p3hDoqYvui3ruh6ZBhaUg2pQP
 dv4=
X-IronPort-AV: E=Sophos;i="5.75,354,1589212800"; 
   d="scan'208";a="245535418"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 17:10:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UI4v3/RjWA3gYXiIeuhsP6O54jMKu0FzOgGwLoZI1OwcHYEA6k1o6tWVS6c+KWutXeTGWtCwsHGVChxUK7+LSQQKCxA9JSPNQTWHrJ8/+iMvsf9Bki+kpbCsNXatU8P+Do6SdUChtscS20QmMDsZOTWnahmh8t5kZEyQudCDZpxSe25RvHO/fdXeKRSTtNS6MbUFOZaAJKlFTMaaYTV4q5PItZPNqlVe2A/XYYb7Y12zqi/opVGMkBgZWPxkI7N2RDyVYHo3MxL3iatsWKQdnoV2jQbF8aL30p3SSKPDhZmwK2NCvp3xvXk0/Ph7EGe4WhxFHgvUgTYCkAoeyt4S0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06fJFZWd6sl0HikPjgaaCQ3i4Uq7du3/07/cqQkebcM=;
 b=dPZZOr4vuYdJwLcSmuCWevSDodxbsyMm5xDlNl6nB1qUYVqEhdyIy1a6SPdVVdxDc4nxeY/JyQNfuHC5Q1C45cJI0o1KUS9rCOwEwTOA1PJ5CO4H/mjYidRNAzDpCmbBfAw7jErFbpnl8LGxHhK45W+XDLKzrPx6S8QBTAq5jWw2s3lvuMCn9N8Gp8oRGI4POzb8X9KtRytTdEYayFyS3iG/4G5P8ZVQ9zJzE4DV5OU1Dnjl+94EqAHwYcQa16hO5ImqdkZj9Y9SVMWoFDZFfaA/0g70vayZ7gVfZoLpx47n3OSL7kHZFxrWdEvI61vJyHj0fLgQZOe/v9bYlgswGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06fJFZWd6sl0HikPjgaaCQ3i4Uq7du3/07/cqQkebcM=;
 b=M/+tzPku4hXLymzMN+/RmiSn2NTpTu4ItrpgxXp/PWP/XbE598q2qcYQn90etU0tOe16IUbFVUnFWY8LV7NuXR7Oc7z1aIYtcqprqVYm5KZqJHdl511jiMTyLTaBiMEdGJ3q4BCf0gQcwddDP3XiHCRLfq5hHmXJVvytgt700CI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3886.namprd04.prod.outlook.com
 (2603:10b6:805:44::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 09:08:46 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:08:46 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 01/17] bcache: add comments to mark member offset of
 struct cache_sb_disk
Thread-Topic: [PATCH v2 01/17] bcache: add comments to mark member offset of
 struct cache_sb_disk
Thread-Index: AQHWWmtGx3U2hb6mEkOjRpATjlZTlA==
Date:   Wed, 15 Jul 2020 09:08:46 +0000
Message-ID: <SN4PR0401MB3598A8BA332C0148A0494B459B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-2-colyli@suse.de>
 <668b8126-6a34-7029-dea4-2ad0ecc3915e@suse.de>
 <f48d11e2-bd17-ba6e-1bc1-b496929e5e59@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:853f:9b43:c773:dd89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 649aaf0e-ba84-4e43-3e76-08d8289eae30
x-ms-traffictypediagnostic: SN6PR04MB3886:
x-microsoft-antispam-prvs: <SN6PR04MB3886F7E36DABD778B4806AB59B7E0@SN6PR04MB3886.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YeF31q7CD1tQb6Qruxhm1PRgJp5xq/h66dPRedVobMY99VJo0RaEkrFPzBLkf7S1EDMTbK3MRer4RHYbpNGUJnNmF/vnfKPifqt3LbWAeWaI5PHcCNAYFSMr9rB3yFvTnt3xrJuNQpTtUUcoaRRC7uwtrZjNyYinpubdbQ1gpiKvfMBZo7+iU2BdM2XAoR4sU19KZft2g/gciYEJjrlC3vp34Kt7PqHTklxDic+y0rA32oUBa2XbIH7/7cW29eS4rI/aiZlizc7Q/230Sst1VIbrvjzRaq5wLKAiOebJFwUewiU+yG93yeK60D45y8ZJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(33656002)(110136005)(55016002)(316002)(9686003)(4326008)(478600001)(71200400001)(66946007)(83380400001)(64756008)(91956017)(52536014)(76116006)(66556008)(86362001)(5660300002)(66476007)(66446008)(2906002)(7696005)(8676002)(186003)(8936002)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9GKUYYyLgDHYtckygfN01AXoRDjTPPXebB1L9qVooFbr3msmTJwksiAS/MQfnY5nFr83Yv3qo57/0DJX7fZVcuJRIPfDypqcggdaY0MiOog5PlzlZXlhkQUDglM0HPAtExbcvmRCBPxaZaLVRugyIreaqKByJIXMAisrMTWkGe9rabv/xIzt2GmWN9p9wEZwRTpGQuqm4Wtj8Duk+RrrsuLtmHQgdzxTzju0W6H5F5yY1DVpoaaCIMtgqWli7zcN+BH7CUbBANhfhyUvB9moXDEojqLlBnm3mREwIcrgKr1YVs/NhYRl/F/n0VsIGq3lnaqgpSXQ0fn9+wuV8GlvpoAR5J7XrYx3X6sKfbQu8ywMiH5E53j5FlF37p4k6L8J0Rrg1FhtX6mtcuE37K+lrijmyvi3ZDZUpelrFhs1Qh2vDOK7kHAlbMyKxlx6Q9QB3ybLoXZ/1BVj2LsHzKOTvSsP1NhwJ9MKA8KFkdJF0ZLcJWcHC9f7XTumH4fYMseK4nHeTeoDzyjgDoP5iLcsFd1Kj9/hpTFutTO+z6Hcmtq7Q1gZRH4b6xUTJMLaesOz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 649aaf0e-ba84-4e43-3e76-08d8289eae30
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 09:08:46.3807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJyORBP7AcFEbiVLxkSDHFVKsOaxzibP69IiPh8S5K1M8l9HDKwAXuGKY7wq0VHefuNI2mf83hfUOYy7jcCNYCVTqcfhl3Ak05kUDOzQYCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3886
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 15/07/2020 11:03, Coly Li wrote:=0A=
> On 2020/7/15 14:02, Hannes Reinecke wrote:=0A=
>> On 7/15/20 7:45 AM, Coly Li wrote:=0A=
>>> This patch adds comments to mark each member of struct cache_sb_disk,=
=0A=
>>> it is helpful to understand the bcache superblock on-disk layout.=0A=
>>>=0A=
>>> Signed-off-by: Coly Li <colyli@suse.de>=0A=
>>> ---=0A=
>>> =A0 include/uapi/linux/bcache.h | 39 +++++++++++++++++++---------------=
---=0A=
>>> =A0 1 file changed, 20 insertions(+), 19 deletions(-)=0A=
>>>=0A=
>>> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h=
=0A=
>>> index 9a1965c6c3d0..afbd1b56a661 100644=0A=
>>> --- a/include/uapi/linux/bcache.h=0A=
>>> +++ b/include/uapi/linux/bcache.h=0A=
>>> @@ -158,33 +158,33 @@ static inline struct bkey *bkey_idx(const struct=
=0A=
>>> bkey *k, unsigned int nr_keys)=0A=
>>> =A0 #define BDEV_DATA_START_DEFAULT=A0=A0=A0=A0=A0=A0=A0 16=A0=A0=A0 /*=
 sectors */=0A=
>>> =A0 =A0 struct cache_sb_disk {=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 csum;=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 offset;=A0=A0=A0 /* =
sector where this sb was written */=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 version;=0A=
>>> +/*000*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 csum;=0A=
>>> +/*008*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 offset;=A0=A0=
=A0 /* sector where this sb was=0A=
>>> written */=0A=
>>> +/*010*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 version;=0A=
>>> =A0 -=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 magic[16];=0A=
>>> +/*018*/=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 magic[16];=0A=
>>> =A0 -=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uuid[16];=0A=
>>> +/*028*/=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uuid[16];=0A=
>>> =A0=A0=A0=A0=A0 union {=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0 set_uuid[16];=0A=
>>> +/*038*/=A0=A0=A0=A0=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0 set_uuid[16];=
=0A=
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0 set_magic;=0A=
>>> =A0=A0=A0=A0=A0 };=0A=
>>> -=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 label[SB_LABEL_SIZE];=
=0A=
>>> +/*048*/=A0=A0=A0 __u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 label[SB_LABEL_=
SIZE];=0A=
>>> =A0 -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 flags;=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq;=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pad[8];=0A=
>>> +/*068*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 flags;=0A=
>>> +/*070*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq;=0A=
>>> +/*078*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pad[8];=0A=
>>> =A0 =A0=A0=A0=A0=A0 union {=0A=
>>> =A0=A0=A0=A0=A0 struct {=0A=
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Cache devices */=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0 nbuckets;=A0=A0=A0 /=
* device size */=0A=
>>> +/*0b8*/=A0=A0=A0=A0=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0 nbuckets;=A0=
=A0=A0 /* device size */=0A=
>>> =A0 -=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 block_size;=A0=
=A0=A0 /* sectors */=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 bucket_size;=A0=A0=
=A0 /* sectors */=0A=
>>> +/*0c0*/=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 block_size;=
=A0=A0=A0 /* sectors */=0A=
>>> +/*0c2*/=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 bucket_size;=
=A0=A0=A0 /* sectors */=0A=
>>> =A0 -=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 nr_in_set;=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 nr_this_dev;=0A=
>>> +/*0c4*/=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 nr_in_set;=0A=
>>> +/*0c6*/=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 nr_this_dev;=
=0A=
>>> =A0=A0=A0=A0=A0 };=0A=
>>> =A0=A0=A0=A0=A0 struct {=0A=
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Backing devices */=0A=
>>> @@ -198,14 +198,15 @@ struct cache_sb_disk {=0A=
>>> =A0=A0=A0=A0=A0 };=0A=
>>> =A0=A0=A0=A0=A0 };=0A=
>>> =A0 -=A0=A0=A0 __le32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_mount;=A0=
=A0=A0 /* time overflow in y2106 */=0A=
>>> +/*0c8*/=A0=A0=A0 __le32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_mount;=
=A0=A0=A0 /* time overflow in y2106 */=0A=
>>> =A0 -=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 first_bucket;=0A=
>>> +/*0cc*/=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 first_bucket;=
=0A=
>>> =A0=A0=A0=A0=A0 union {=0A=
>>> -=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 njournal_buckets;=0A=
>>> +/*0ce*/=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 njournal_buck=
ets;=0A=
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 __le16=A0=A0=A0=A0=A0=A0=A0 keys;=0A=
>>> =A0=A0=A0=A0=A0 };=0A=
>>> -=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d[SB_JOURNAL_BUCKETS=
];=A0=A0=A0 /* journal buckets */=0A=
>>> +/*0d0*/=A0=A0=A0 __le64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d[SB_JOURNAL_=
BUCKETS];=A0=A0=A0 /* journal=0A=
>>> buckets */=0A=
>>> +/*8d0*/=0A=
>>> =A0 };=0A=
>>> =A0 =A0 struct cache_sb {=0A=
>>>=0A=
>> Common practice is to place comments at the end; please don't use the=0A=
>> start of the line here.=0A=
> =0A=
> Hi Hannes,=0A=
> =0A=
> When I try to move the offset comment to the line end, I find it=0A=
> conflicts with normal code comment, e.g.=0A=
>    __le64            d[SB_JOURNAL_BUCKETS];    /* journal buckets */=0A=
> =0A=
> I have to add the offset comment to the line start. I guess this is why=
=0A=
> ocfs2 code adds the offset comment at the line start.=0A=
> =0A=
> So finally I have to keep the offset comment on line start still...=0A=
=0A=
Why at them at all? pahole -C or crash/gdb will show them for you if you're=
=0A=
interested and if you need it in the code you can use offsetof().=0A=
=0A=
I don't really see a good reason to add these comments. =0A=
