Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2563E1D5E6D
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 06:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgEPEGe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 May 2020 00:06:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:12382 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgEPEGb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 00:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589601991; x=1621137991;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Bwsl/AdRtdZHDu46M6RELNYVZ1l77UPEIVliTnlWGtQ=;
  b=os1ngW/VdHlhA7Uv531g8MVIsu82Cz+uWdqqaFRUMerXbuYzYftRGpSG
   PIvVI4q0oG62WotQda8yVB/JsKJYwf462bHLozaLXQakmfnQam/T/qYHw
   iiTq7baAZDaoufGKQCf/+6JyvauVWo1/IvcmAkdFQEncoTJeeLrVq42FO
   5tAlRIIvzaPPufv11Kg2Ywq3VG1GEkDirnaR/eyzCfI5jCXz99DBV/5N6
   DttRXcX3EJ+8QK0RJ8VruhBoYHVIJzKvNSQp8GNL0LJ7vY0Z3t8kaY4w2
   QfKYa1hrz+ZwuCszvvo4PiRKL0tA5gNUZLlQgcb+ZdEaq3RJA8du4cw0O
   Q==;
IronPort-SDR: K6Yo8yg1LiAq0MGWdW84ZnAK4LOqQG3sKWaLQWo7w5OFSivseiRW6gHHXVsesPm4IalGWN0Y+I
 xUpjIVfNvevMaMtoHB2vI4NuY8vCAAy06UOEgGkOkD2EVShjnY6nC23JWrsCPluVRagUNNoArr
 cL1dSKMmlGRPiPAvYyn7P90U8O2MGLbmORoa7i6Ul1iEJo2fSQN+s6AqOH8luo/Z8+9cwO6i6T
 s7TWY69fTi8KLpXdvypk/kELkt2wCQkdv0Nl3eK6Bv60xN96wLfUZ9MXLIFiis2gkQNoIb7BW5
 GBw=
X-IronPort-AV: E=Sophos;i="5.73,397,1583164800"; 
   d="scan'208";a="142170487"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2020 12:06:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAFJ5+Iv+S8dQ9QlZSLndbWK0FQEwWdfwndKmVzkuWVZzK/yEElWVkP9LrDOibXdulzvko+Vxsc0153OoxQiXrSGoMzH4TY1jK814YxfxHDhA7sOqj1SgduC4Ruq7DiRJFlZf96snWhkHDGpexIuJbOjfNJrqfx8RUPkYb7MvAuvpqYWc7hg644igVIxFjPAamZnA7oHSBW7HxFQCSwTAB81frVwCoxaJhAXiGrs0vrv9lhwW+fqhON9Okgs9Z2L5VLg8L+mIQv7ZQ+uf/9uHgc1nh6ZHIeLWwcIlcMXjSyPZtRSE1WH4bgRhZMYe+d7e+7sfSHcncv7k5WA8q63XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbrab5B9h6yOxMPL1Btd2Q1gETzuBxTAAKmQ02vwwmU=;
 b=YzDr/kApjc7Cip5vT/yE/8Oo9sWdGWIRVspOgB7VpXW/BWNiWPEYl8BpOcBtAO3UebctT6SnYfFk7iIDNQyDh5VVWDASwSgn+RnDoTp9ij1zQ2w2Fu9v2OpMaLhjSh9aIIT983RR1RRYM5AqOBDQk5vYIKGVqPVqNxAcMQ5QAtCt47DeKadFlWSNj9peIJxrd65rGQthHmFPmnWXn8sLi2xLUpYoC+Ma63kNSXlt9mywNUhY6sQit40PsB9CuQGBO5WCbk+QB0+EOkws6GfV2NB+rg/tamp7e01IIHQxKGvtF55uY0qkdIJpa0MWXcGlhT79AK6hafkC4wueRC5Kow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbrab5B9h6yOxMPL1Btd2Q1gETzuBxTAAKmQ02vwwmU=;
 b=bHxr8G3xLaY32Sm+D84iRyn2FJr/BYuEE27L6I0jV7ni6wmNOkrDVJbrexuCXU7azuG7/Qjz6/bu/ZsZSK7h/rWgl5WQ4R7xiYS+LC/awqInmvpiPOXVcm56uX2plQ/7HAWv0xs3LJn+O/+E2MP4u7V2Zf4h6u34QfOh6tT80BQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4711.namprd04.prod.outlook.com (2603:10b6:a03:14::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Sat, 16 May
 2020 04:06:27 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3000.022; Sat, 16 May 2020
 04:06:27 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Topic: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Index: AQHWKzXNx0htYVAnNEmE+sJXY3ZbhA==
Date:   Sat, 16 May 2020 04:06:27 +0000
Message-ID: <BYAPR04MB496596D3B85F70D25A1C6E6986BA0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 673c3b7f-b86a-46ff-5906-08d7f94e81ad
x-ms-traffictypediagnostic: BYAPR04MB4711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4711AEC58A9FFA97FDB3261B86BA0@BYAPR04MB4711.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ef4AdG9wsUhiCCdel1Ka1JlDTBEbC6qXrZsjLR4yDe56NXBCyiwCmOKh+yrnEtrp/BDWM0DRxwau0gu/JhHdxZGtFFIwVpCgbrqyVE860YAbxxEgkPRQPNbtjc88PQsaEAakqRE2xQuw3rnj9T6EZh1YdIr1m2rFqc0SDgu/ysuTEaltAz1TWW06Ih7eu4p1DOpS3TL75aD7uo49evofH1w0cl1kO6fpHeG1K8jetOrhxFxhLvyB8OddJCXRWkhGaCFyEok8vWH57qCpAI9amCrtbKDA+qejCn1x2tq/7Hw2eoMbAIfGYBkojLF/59RoISDxSY4Vgo86AMqTuVRLqLjRsYrtgnZdJ2pI91j5h/DE9lkaSKHQrGesWJCHDZxz3ZdzhlJlOsFN/TQrOE3o5Rqivvco/Bv9lu7lPwccfbUqK33rwSFDlLAuY1rgphdn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(8936002)(7416002)(5660300002)(33656002)(478600001)(7696005)(71200400001)(186003)(86362001)(53546011)(6506007)(66946007)(76116006)(66556008)(66446008)(66476007)(52536014)(64756008)(26005)(8676002)(54906003)(9686003)(4326008)(4744005)(110136005)(2906002)(316002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8PXsGko6CDOHCh4KphjfWY8uRi2lSEfd1+B0UP1kIfbx6qiu9EtIbwc9cHt6EVL80VluGVkM26bzdQoKmGUhFhlAofuk3H7ZAkVST89n9gCsccJPrlQ8iWmYmgL8UOZ+IL8L2zlrA0SOo6XPF+R7qMIJrxEilkJlVhiYyRqY4g5G0c+LnqiC1XuZVg8kwq1yNy6f83yMwF1DMJZ/PmfPmH0vZTe8cYUwoYdPCTqf8IPtZBNLP6DWdE2TRkJKA+sRMv7JhPLzBFLy9+e+a89nbt3Dp5/+GU/+fubZhFvStpC6iLCO4lYPKiFyMduK7f9w1nhmok/CaqfbVIebMzTlljiSzsIMgu2qxf5jMDefCK/hbzrr23wdD27EeoVN8z4waQndoGP0oQKAMApNAPHYv2e6XFDrd/Ka2TuWpuyhCN7/UtGqiesk5zho3X4OxPW9CPHFWxD9+WplnUxl5BWtgqlOdfBlZTzme4oTsyHYlOw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673c3b7f-b86a-46ff-5906-08d7f94e81ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 04:06:27.2772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRoZFoxQIweqIMTPDIjIvmg9A1IZt6odY2n2i9yJfA1OcjfcFxPGtmElejMquYvdsEvpyyGT6LYf27iNCfWbT/SEpFhs/yrCHfsSsC3Ze6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4711
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 05/15/2020 08:55 PM, Coly Li wrote:=0A=
>   	REQ_OP_ZONE_FINISH	=3D 12,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 13,=0A=
=0A=
I think 13 is taken, I found this in block tree branch :-=0A=
for-5.8/block=0A=
=0A=
316         REQ_OP_ZONE_FINISH      =3D 12,=0A=
317         /* write data at the current zone write pointer */=0A=
318         REQ_OP_ZONE_APPEND      =3D 13,=0A=
