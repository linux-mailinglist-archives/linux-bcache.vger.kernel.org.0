Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612861EC65E
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jun 2020 02:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFCA6x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jun 2020 20:58:53 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27074 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCA6w (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jun 2020 20:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591145931; x=1622681931;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=yYymGoIeL0UufJvU2FRsB/xprRAHsiNZGq6+9oRxVk4=;
  b=KbZrUF/XbfhGWdq+Uxj+/SgKDdUXrczqYHD3H2fAlVVHp/e8DqcOVh99
   QBIl49yrZkzmjUp8xgDDctKeH5tFUodb6kn/MWalqTzqM+Im7XrrWsys9
   pkKHo018XAURmIse5bM7aDCy6O7neQkR0zHu9sL0qhB/3UJjsOBVQUvYO
   UxHFMm3sqFA2FPPohhskBbgJcX0F9ML72ubZNW5O8Op4+DfEhCmtmJF9N
   aEJXSRSXWXEQgeT0G/Q4p3ZGq3PnQxp4EnJPoHeePKG0fZ3r1hMiJbvB1
   4I6be/tWeOH7+g2e74Xicp/f3sF8xp0fXNGkqh8c+RPL9/fq3V/vSO3Ud
   w==;
IronPort-SDR: QMo6xsS0eOmvk/8dDDdxF1MgkWMJ7kUIMlpOf8NmYddLyj3/BLWP8g0YyoApOTxpteXxvTj/3K
 V0GEbgx1x4uNNRIkF+2JJLJVcRBcUbfe3FncMVre5c67R40veEm2iFu6e9zalP75WRdvohrnxl
 +HEISRwlIV8GoilI3eZql00UDAyD7U38k9MqZXcobTXtOqzklYv6GP4vayKIzeJMeDKnRiLJ4H
 Wo5FYsM1LWtCWzSjjnSMOViAXf7DosOeb4KMf3xOe8w8MDyaSSx95hto2EAUA/AUn3Nx50zhvv
 hbA=
X-IronPort-AV: E=Sophos;i="5.73,466,1583164800"; 
   d="scan'208";a="248158822"
Received: from mail-bl2nam02lp2058.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.58])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2020 08:58:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWrWfGXSvu69P1AvDdsvZ8UVTBG1hSUs+OM/rLCMXx6ti7D3wp/YwSQiAPp1wuMWEJL1/r63Xg9PxGir7cFwiiNBYqeKhpuODmaFfXBhWaiIKv36+qH7ZwiQiuAwOEm7EhJfUXOhXU4ekLKhSVvGf6xAN5doM1hjiXEzNrpaylJeAnNrJyxULU+nLRVqsNjZ3foqrjoBAqgMeD6v5f9f3H2nkCiUuBSxqspZz86OAgDKcLtUZpvy4yoYa/jCMLxU543k4wxzKDjYmD7nXiZWymXtuQNoJDzCyq6zprdDn6r+5SX7BuBTKyBaBVHH8FrpMo8HglPtgoNQX/UJyXb+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wL+BZF9y9XqChCCgz+BMZBkrz3FC2BONNZRxLaMCLQw=;
 b=EpFIMBtI0d8xkajnoPmouuuJrA7EVBjoakzGwnOVxVYM/nEUkMiWPMucg1XO1ZO01xM+aifmmSZq8Aupt5nJn1JyWgPbfW9PnNV5J0fE3WatCQ5R8NhOllt1LdD7RWLmeqNqmPDwOdjlHJapUXAorn2FTZ2r+8PmQJAnk85JswFCXmhVUaXFCHNpm6ZwlBPGYI93rgl4br/PXybycdNINlUCVponmTrbUVrb0u3hdvcb8SDiPewhR0WLhm5qlc40TaXX9sbPyXGtdtjSkdpu9h2jBBlgbxHTeOljF90q3ZlTJdUtLZzH6fc6ejafDHORxwDqo/HP5Yzda5GojiVnGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wL+BZF9y9XqChCCgz+BMZBkrz3FC2BONNZRxLaMCLQw=;
 b=frE0kMLI04EgR2QAdNWRxn5lGPDH4iLB5eSzWItEjKJ2L5DhKNVizYi0rzg0TRmY+p89HGbe6Gy4QOWf0iNn4yDgoEJGSXr0oAjh4w/hzRn9W0MRyZ6KHLFxClZTM7pzoeFUZAI8y73vguB9YTjFxsiFaTHF4KnYhh19ydifaqg=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0536.namprd04.prod.outlook.com (2603:10b6:903:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 3 Jun
 2020 00:58:49 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 00:58:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>
Subject: Re: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Thread-Topic: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Thread-Index: AQHWMDMpe06BbBUQGkCzgleoTRnAkw==
Date:   Wed, 3 Jun 2020 00:58:49 +0000
Message-ID: <CY4PR04MB3751543D5DA3C799B4C8A196E7880@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-2-colyli@suse.de>
 <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <1c124ebe-3f1c-6715-0c1b-245ae18ec012@suse.de>
 <9ad1e32ddd1d93ad4120723d23446160a0877752.camel@wdc.com>
 <c6492f79-423e-b37c-261c-80e4b26081ab@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a24ec2af-3f61-451c-f688-08d8075946a6
x-ms-traffictypediagnostic: CY4PR04MB0536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB05364A5C5BF1CFDA03D5CCC9E7880@CY4PR04MB0536.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjDaAaapELmGOBa3WoBhmTxUMNFJLx6sXWlYngSQnY3tbayOpRJ1G3ZDUiUsceALHpIRrbST6ELJa17gRjOalPuJM/rnbHI+DEDmK2oMvLOss6WJOMqJvYqfIppvM9guX6Tt0X9O4yvhD8RukxdrmoVp6tMRtpZ7Ejzllfs23MulQzrNBnuCO+378yZn04MJfkQKK134RwL6UhNu0RRIpsSeWpqiu5zMEGK6r7kXT7Ajq+5hfwVD/viEtmZ9av6h1x8x6935xi6/iOk47zLophlKbfXUq9IRBFUJ7B+N8FHKCgkpzS8hhja8YAbTcsinisWgdx1/WMhZOInbhMhiVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(8936002)(52536014)(71200400001)(66476007)(478600001)(83380400001)(66556008)(53546011)(5660300002)(6506007)(66446008)(8676002)(64756008)(66946007)(33656002)(7696005)(110136005)(316002)(86362001)(26005)(2906002)(91956017)(55016002)(4326008)(76116006)(186003)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pizjKyS5AKY2lm63qqqDZq4SkT9pml0aPWOaFzp0CGDDpD7b7KPK/eayNfxl2PPVfdOtxSFAWS51rArRvEXXxt2uQjbbXMviGROeWiRxnRM2x/AjsqHcFUUXCFIlEQ07/0dWjljUZ/aAOE3fnP91wQoEmtVudJT5Prj+CHezboKDnMSzpSf9QwHppdHbwMMdmrV9ffu0pquMGqRuPO98OdP1Qki4Smxmg9CV8H55Ng3FO1ZIEjP7Aboi1f/36cJSS34XkHyiLP11QozSdNmp7oRBUa2D1ntA9fIYfB8+X+pW2/GsILlUv9hf7pqWf4pYKQCbrLeFBhTYheaCAjhND5uDkhqOCefltUJx3WDv8TxdVBiP9OOtJ15W+j8oBSYAb6vSGsKQTkB6YGD8KeiLB/nxvkMbU7YE4D9MFMvAI1pXdQPVhe60E2qFraWQIOavDJ5PGXxlqilley/Fdab59Lp+/n/3lqPRvhouQyl8q84jZGErdzSnPNeB0oHfMd2p
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24ec2af-3f61-451c-f688-08d8075946a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 00:58:49.1056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZoUFzbABda1JY4SilI+fLAHd4v2uX4pyk+QV2k/9vrTYLUDtKA8HHedk6ObbYcC0a1ZZv1RuiG8Ne0XJorm0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0536
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/06/02 21:50, Coly Li wrote:=0A=
>>>         /* convert back to LBA of the bcache device*/=0A=
>>>         zone->start -=3D data_offset;=0A=
>>>         if (zone->cond !=3D BLK_ZONE_COND_NOT_WP)=0A=
>>>                 zone->wp -=3D data_offset;=0A=
>>=0A=
>> Since you have the BLK_ZONE_COND_NOT_WP condition in the switch-case,=0A=
>> this is not needed. =0A=
>>=0A=
>>>=0A=
>>>         switch (zone->cond) {=0A=
>>>         case BLK_ZONE_COND_NOT_WP:=0A=
>>>                 /* No write pointer available */=0A=
>>>                 break;=0A=
>>>         case BLK_ZONE_COND_EMPTY:=0A=
>>=0A=
>> zone->wp =3D zone->start;=0A=
>>=0A=
> =0A=
> Correct me if I am wrong. I assume when the zone is in empty condition,=
=0A=
> LBA of zone->wp should be exactly equal to zone->start before bcache=0A=
> does the conversion. Therefore 'zone->wp - data_offset' should still be=
=0A=
> equal to 'zone->start - data_offset'. Therefore explicitly handle it in=
=0A=
> 'case BLK_ZONE_COND_EMPTY:' should be equal to handle it in 'default:' pa=
rt.=0A=
=0A=
Yes, for an empty zone, the zone wp is always equal to the start sector of =
the=0A=
zone. So yes, for an empty zone, wp - data_offset is correct. But it is not=
=0A=
necessary since you already need to do zone->start -=3D data_offset, all yo=
u need=0A=
to do for an empty zone is: zone->wp =3D zone->start. That is less arithmet=
ic (no=0A=
need for the subtraction), so is faster :)=0A=
=0A=
This code you have:=0A=
=0A=
	if (zone->cond !=3D BLK_ZONE_COND_NOT_WP)=0A=
		zone->wp -=3D data_offset;=0A=
=0A=
will indeed lead to the correct result for an empty zone, but as I explaine=
d, it=0A=
will also do the subtraction for zone conditions with an undefined value. N=
o=0A=
need to do all this. A switch case handling all conditions makes things ver=
y clear.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
