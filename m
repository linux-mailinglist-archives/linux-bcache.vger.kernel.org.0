Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4193B1EC65C
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jun 2020 02:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgFCAvt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jun 2020 20:51:49 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30986 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCAvs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jun 2020 20:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591145521; x=1622681521;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=oGrwVO1Pa7VYl4Mzfip9YvNy0uNsQARlunm9Cf7sOmY=;
  b=Y2nm59P9r3Ubh5KIzAzNlFG8gSkbeZFC0RB9iq+KoutoBm1RlZP5Uyos
   enbYmBPAvdEScJIV2DuFXs23CmruSmtZjPhz/PZ3TK5xMWAgQ6/7oaa/F
   LTvDzyjfMGCtn+E4QBSWD4ahGAkX4SkeyE1QqO0Y3FYJDejqgusy5/1jC
   cdpCeFyI5lEi++Q7/TP+ddh7eb89z/OvSO0yiriaa8cOV1IKXrYn/XJA4
   h7Ywhvj+sFowrUXOjvCSBhZgSafw8qzfbDP5EhkfT3m2ThZdwNMB/DxQO
   hq5PAoAfTK0J2vuoRF0BraZ68DiQpMR3MpiNIyfET/ekS27E+vICbxJwd
   w==;
IronPort-SDR: m7hXJS4fr1nVb28v0svKDiHTVO/lvKZOlcSLDamr5M+joHCbbSGjiYzEyXmtGq+4h3dzdyj6Ad
 I7a3B/cGpANLLwMXfswJ/l8/VMcg6cBICbUurWVmQcIuPp7q5rTTwmr2U61TJwhTsy+wjnfQhg
 hDBeOjhOo5khVbTcG0NEXliNCq4yLx2LwfiQVMpT3/UquXc83wUSMSymNkSg0VAa311JMGstGZ
 ctQqTF5+51FqQOaYfr1nNHDLh71e5ccDNMdJXi1ISZx66jXxOnlbEcq2ofePvpxSNr12ZpihP2
 Q5g=
X-IronPort-AV: E=Sophos;i="5.73,466,1583164800"; 
   d="scan'208";a="241930004"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2020 08:52:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSua9iEA1R0GHfYC3GTE5W59bTCItt+iU90XQgkACyYK2hc8cS+mDkXiavdzbSrczXvtJYRRMDlsX5R4qZ6snOAA7xKy6ISmarsfQxPJhRsdUZeAGCEBzItFnMCxOWYL1tYlzzVIzUMRtw8uU4VoNQdgh3I2mAlJDwAfXd2ergQtz/KUcUR3jXKji0kTQWT1PgiEl8r4/7pflYbfK2QZqvoS3Fd+GGP+diRFDjYxPIR2C9SD7RarEBgxTUTpEq1IYr7BdfZ50rOYtLYT+3E0naECVKp/FmWuYJxFHENl1uGuSiq913OMHdI5mOxXe6Rq7oIla06rLZxQvk+GQ1oXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+T4HWgXjpALyIJp4/LaLXzK/m6VTt+b4gv/2wDUxqE=;
 b=HHwKT9kYRZRPk4aiLlk7Npk4hRE9TB5Zkd9Ky0mnNs4ttjqo0o1rUGDr8qfFbNTflni888bgPNvr7/I+cLzRb5O5T0zrxMOkUnDsobryBHLf/gAIM/4jmn9hwxSyZsp8NjeGD+9hC8VkmrDRF53vFW1dacVDCeSARDppjdHiSofdCvpgn+VjWjXcDQOMROsd6xcpIhl/85yRbsZk3Eer7TssCCTCPb0hE7vROwoqXJ8DO3RKRckLcu9yOP6HFbxU/ih8FsZNWLOBamIYOPpa07JLDcOUrn7EOOSI41R0mdRE49zQo6GQ1tXOuiAEdvNboHWwrUwpMcXsyTDExucd/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+T4HWgXjpALyIJp4/LaLXzK/m6VTt+b4gv/2wDUxqE=;
 b=ghF8BOdqugfS1y2y5zN/qfjM8qfwUvrUJlBFrNthy0ocJKtqZ6Q1/ouAxqFtovCGrOXxTfYDYDwfvnGEdictflxU+h7EnT4c2/fMelLgUOfwIK0O6xjWt5yOOODVBbiVUqUGRWHZQjHABFKVaEcNsCBQSxiI0Q/BclLgvhlCz0M=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0518.namprd04.prod.outlook.com (2603:10b6:903:b1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Wed, 3 Jun
 2020 00:51:45 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 00:51:45 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Thread-Topic: [RFC PATCH v4 2/3] bcache: handle zone management bios for
 bcache device
Thread-Index: AQHWMDMrALMD8aFhJEWGpHp2plS4gw==
Date:   Wed, 3 Jun 2020 00:51:45 +0000
Message-ID: <CY4PR04MB375123D5B0E99781D1A3D319E7880@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
 <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
 <05e3dda28565c85f5beb0055a43ca4f685572431.camel@wdc.com>
 <e73f00de-f5d0-a8f7-e7a6-c3285fbfd368@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd1eac24-70a2-42a4-8a2e-08d807584a35
x-ms-traffictypediagnostic: CY4PR04MB0518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0518231F2DCF4F7EB39C95A4E7880@CY4PR04MB0518.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rMlnHGaCJF4aq8CFMd8M6buf5Jf5/qhCFP8uLPr3HGZs6KahFnkQli8ilD3ezzZuFS4BkCdTQPCmOZnmfGgi3Il+i6XYWjiBRcJzXUFubZX+xDSTlna8hJzgeHdEPKB0Tzpj0aplhx8rIyWRAxeoGAmo9SYwUeqwqqR9vC7RdsgdvttkROslw+6dcJLqQB2/9q3LKNrQWEM+/bUGzJ4TI9yF3zlq+1VWouAHl4aCRCGb8v7pay5VNa5Ny6Z6NdIdgBTek180LRGCBXHQg2ldFBMNRJWlRLCHCjHkhO35i8cvL9EK6XEP4UspS5gcdAF27hS7EvItaUlV9wat+QJSBYW2RbmOe4N2ovZB1gpg3qsZNRi/IZcXpyfj1D8kgSiM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(33656002)(55016002)(71200400001)(83380400001)(5660300002)(4326008)(9686003)(186003)(2906002)(316002)(110136005)(54906003)(478600001)(7696005)(64756008)(66556008)(66946007)(91956017)(6506007)(66446008)(8676002)(53546011)(66476007)(26005)(76116006)(86362001)(52536014)(8936002)(6314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Yav1b5rpKJx9a+PsYJQDGxZR9utwUNaQZTLHM3aL5+4zEtwSiATqoZ8wIoKd8gkPTwWeWIcyDi/SipBK6BwOJdC4MARwsvImpiltWDE0VK3+QIJIXJPexfqzn08aY1fKiXIVLJadfp7ipEXc2KANBNQDcfe2uLxxWdPiV9FsioCXHFFUiMQfkk0CrUqfUBSIRQa385LQ9Cu8QPwzx+O45s/frjZJeG4/Anltrk2ljdZ7F5qRIEeG+R3VukIHBWxfdwcxCpcn738hjsrXpPxHI4QK1AO3PkYU54qm4+n1279W95koIsFVvyDl2A5XyGliYawcQGTNsh5SbUUTHW8jiBjZL73kcJTQM0UvNbmLVFzIeTjXbJCMpKMwIjyubgXgR7d6GeFA9oPEtwbEtrV914I4iPSfSLSm8AeB6DXKUinXB1A33MShxOepy2lLU5xLd9Gjiu+8Bzc5Pt7l9wKaDt/IwOStb+ZLb7CmGwtKE2u/SXf74l2HSqxocwqxqqxO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1eac24-70a2-42a4-8a2e-08d807584a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 00:51:45.5584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gZVYewmaY8Qq82bEg07DAk0ViKzzcOkXJVGfdFZ2ocKqZbfzd0me7eSMXKhU0lp2gg52kcAuYOUcCN9Umfq2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0518
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/06/02 19:18, Coly Li wrote:=0A=
> On 2020/6/2 16:54, Damien Le Moal wrote:=0A=
>> On Tue, 2020-06-02 at 00:06 +0800, Coly Li wrote:=0A=
>>>>> +		 * cache device.=0A=
>>>>> +		 */=0A=
>>>>> +		if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL)=0A=
>>>>> +			nr_zones =3D s->d->disk->queue->nr_zones;=0A=
>>>>=0A=
>>>> Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be fa=
iled by=0A=
>>>> the disk... This is not allowed by the ZBC/ZAC specs. So invalidation =
the cache=0A=
>>>> for conventional zones is not really necessary. But as an initial supp=
ort, I=0A=
>>>> think this is fine. This can be optimized later.=0A=
>>>>=0A=
>>> Copied, will think of how to optimized later. So far in my testing,=0A=
>>> resetting conventional zones may receive error and timeout from=0A=
>>> underlying drivers and bcache code just forwards such error to upper=0A=
>>> layer. What I see is the reset command hangs for a quite long time and=
=0A=
>>> failed. I will find a way to make the zone reset command on conventiona=
l=0A=
>>> zone fail immediately.=0A=
>>=0A=
>> It is 100% guaranteed that a zone reset issued to a conventional zone=0A=
>> will fail. That is defined in ZBC/ZAC specifications. Resetting a=0A=
>> single conventional zone is an error. We know the command will fail and=
=0A=
>> the failure is instantaneous from the drive. The scsi layer should not=
=0A=
>> retry these failed reset zone command, we have special error handling=0A=
>> code preventing retries since we know that the command can only fail=0A=
>> again. So I am not sure why you are seeing hang/long time before the=0A=
>> failure is signaled... This may need investigation.=0A=
>>=0A=
>>=0A=
> =0A=
> Copied. Currently I plan to add a first_seq_zone_nr to bcache on-disk=0A=
> super block, its value will be set by user space bcache-tools when the=0A=
> backing device is formatted for bcache. Then the zone reset bio which=0A=
> has smaller zone number will be rejected immediately by bcache code.=0A=
> =0A=
> This requires on-disk format change, I will do it later with other=0A=
> on-disk change stuffs.=0A=
=0A=
I do not think you actually need an on-disk format change for this since th=
at=0A=
information can simply live in memory. Also, it is not entirely correct to=
=0A=
assume that all conventional zones are at LBA 0 onward up to the first=0A=
sequential zone. It just happens that this is what drives on the market loo=
k=0A=
like today, but the standard allows conventional zones to be anywhere in th=
e=0A=
disk address space. The safe way to handle this is to do something like the=
=0A=
block layer does using a bitmap indicating if a zone is sequential or=0A=
conventional. Not that using the bitmap already attached to the device requ=
est=0A=
queue is possible but not safe since the backend device could be a DM targe=
t, so=0A=
a BIO device with a request queue that does not have zone bitmaps. So alloc=
ating=0A=
your own bitmap and doing a report zones to initialize it when the device i=
s=0A=
started is safer and will give you something very solid with no on-disk for=
mat=0A=
change needed.=0A=
=0A=
See fs/f2fs/super.c function init_blkz_info(), that is exactly what is done=
:=0A=
allocation and initialization of a bitmap to identify zone types.=0A=
=0A=
> =0A=
> Coly Li=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
