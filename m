Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B421954CC
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 11:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgC0KFi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 06:05:38 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58556 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0KFi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 06:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585303538; x=1616839538;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=FZqmIF6EIIJKtQpiiubrCv8VCkPx7Pw3+8cRCScmmEsK7ZrsxplI3BhK
   6sj4396zvOT0BBecO01Cygdf+8Cp7E8PVb4N5YET5wRK81STkV7vNPzVo
   YlPxJg5sd+g+J2JHI+/5RnmDkqYg3adoti0G2TyyCYYmENu70QFfXkh5g
   u3Wj+j8fw9JBUp+PHh10sfV6c2F/mg8eMzSuRTFCzbB8RL2j2vpgnZIEw
   GKRozovn41DTPKOa78bvQOow+0qkwF/c829k/OgEgPaxAWWmbgDiRdWbL
   STUgVrfu7QXHVhzCq6RYobH5o8b1776Cy9crGxExrqS0d4Du0ww58nHnk
   g==;
IronPort-SDR: yTBbJBMShpJDvhW1ZBQ6fLuyqakNDkCgqqiS42W00Sw6uFHNqG7JeRSBG6wEGhWvFLO58oVfak
 gMJkAJJZXLhHzHLWHF8QQeT+UakGs+NWWWfUwTgrjIYn/00+Er1hIwhSdJyDIM2HgiaV9YFaww
 HyPeBrSAvsHsV7ZjzhiTFVgbeERzDzOx77Is864c+6tiR1nXgte30BrksS1iZ/0zOaQo2pfTzS
 PbCQitRJtsX9rLAizb8BbMp3CVuAuGw0mgHDZsJD4Sme2fPyiJ8r+Z18e0WUUlsY8n2KFaRzeb
 FO0=
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="134103057"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 18:05:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1uZIErUqBCLExBVMonSZUNRi/D+eIm5NnF+3vuxo/jFkjMR80XXOnoLCVj8YiYj5l8vuSMgfaFrozL5HPryYjdmranIB+jByeYarmqi5f9XKxeHrDxsKNrxPstVkVFsMnqY7ORsQX2kHGGLhxR47EORmxGhoy707V9uCvHxHslCRgeEP3icGiaaK0D0CdXVO1+JeWrBp5yL4rDqGHhCZC90kCpZKaAL/0rga6nv44Jl0FqlnnrY1SV5lMpav1hiADq+d03KWka2sV2AJcfh+CA+fv2qOU/JRi5izCDH6cgs3MSZEaPVKFie7gtOHzYMaSADFAH26TLh625IUdXbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Gyo/rDuSQuzFWIvhTTjnCGiX8Ei78HZFModjbHHCzmS07QOnIRjHpYVQlfs95gt+vCR11RCU4lkVATZF0b6LmghNR7dYBLh3GDgR1HcJ6Z8dOpA8qf4bKNsQ0jTKf3WR0qi4/LcC81mpGOzNPLyjLzCVDMkP9PKNXJ+fYWC3yzPI9O06M6suH8rWu8Hi3gG28wc07//ecqiekxPS8NuY6kNVgw8HdLj1glIBTFZJ1Dk+vT+Cx9xRdvsOhQAk70zVsl9NN5DACqJ2CfQ1V0ZZk7FNGjthk0xFDRohyl3OpDg7s0Rt/j21S5FjGMyntCxhJwsYEUz3jlpk/7wc3g8MOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ggejyuZ+vlxMIPqe6IFFjfNtuNgQC1NlCFkFDvMAp8hX19WT+1ezM7iiglj23XCR7d1rZm+V6FR6J2I0zIgiwA36VhN8J1plaKKONMMdeg/B6fNxJwS6nlSDMD62cAIPqrj9Riw2qbswUG5ItbZMa0nJEmyx6gHmMK7nZe5YhOw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3677.namprd04.prod.outlook.com
 (2603:10b6:803:45::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18; Fri, 27 Mar
 2020 10:05:36 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 10:05:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 1/5] block: add a blk_mq_init_queue_data helper
Thread-Topic: [PATCH 1/5] block: add a blk_mq_init_queue_data helper
Thread-Index: AQHWBBKXubXkHn8+FkWOgSW+908LGQ==
Date:   Fri, 27 Mar 2020 10:05:35 +0000
Message-ID: <SN4PR0401MB3598E4E30FCEFB06280409339BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bfa768f5-8aa0-4f99-14a4-08d7d23664ed
x-ms-traffictypediagnostic: SN4PR0401MB3677:
x-microsoft-antispam-prvs: <SN4PR0401MB3677718B6E5CF9640C085D379BCC0@SN4PR0401MB3677.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(110136005)(9686003)(19618925003)(91956017)(7696005)(8936002)(316002)(4326008)(66556008)(76116006)(64756008)(2906002)(66946007)(6506007)(55016002)(54906003)(33656002)(66476007)(66446008)(5660300002)(71200400001)(86362001)(4270600006)(52536014)(558084003)(186003)(81166006)(81156014)(26005)(8676002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mkpqr/57Q9x8wHqYyLs/3DlurBssxu7ocICgpSK+mSUfWCMd+tiehkVa+Dk3Kc+/MBMqFFAZ7+tjInSpZyXNvyk6ygbGDvwEhiGj4+8bzXB5iN0AvwHVTTNMP5h6rtL43/GUMLAnXICtTiy91lZkjEcG0Qv11E5QJlp/3iLpMdWxleYGQ7enRT4oq4Suh9IFQ7nBz2wen2N2T239oSei3NyRNOkw//pcoH0F3noHagh2DuJX1SqmHAtaTgS/Jaw/twzgxvMZ3t3DIZxSapk4PmWYqrLzqx20+ce0vSYStQRRUcT/7F5R/5YBgablble2pTxvr0tXZOKeweLg/6C9yl1AMECG71PyOxP+zSkPWZf0rIDA4dvlKqCkv2qXwoA4jFD9i9Cs+f27FByPwfGUdW31mTpij20UsxgWfhiRj8DxSafYrIyM1N9habN7jMhJ
x-ms-exchange-antispam-messagedata: cUaQpshfd0ScCkSl/MHgA5TITztev9VsYJYFyin3aijgZrzkyND5oYd0S/U5U7LPzeUW0sk/G9rQfnvMdyeXvh+4JteHnfub3sJ9RG+lALwYkFINweeo0CrmljH0hyh3RKDIx+B7gzsXstr/iMiyZw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa768f5-8aa0-4f99-14a4-08d7d23664ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 10:05:35.8171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FET2zeuxADi3LhH9BJ4SmbWgUVJ8RqUyUufuXLijvNr2UpxVYOdGv2e29I/HMmXQ4b7+68mGM9joJjiNEb+jwCYGdHy6gcp3Wl3oBloPZMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3677
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
