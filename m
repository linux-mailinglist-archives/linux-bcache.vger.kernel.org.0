Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179591954D1
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 11:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgC0KG2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 06:06:28 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15390 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgC0KG2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 06:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585303587; x=1616839587;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Zs6tJlVUZgvacj4zASrVnyFvbKSMpyq9wiZEYZB3VVMqyGB2gu+CDbMt
   8503UuNjHfqJjvgMAs8RVYB0o9aOusyX1j49K5HplyJqWDezUoMFt6F6v
   Cms8gCFIHJIye7poVQ1MQnB3KoIrf17ixFSsRRZF3hsc+5CkHvzVzuixv
   SnV+iWBzwcpJJkhiXgoGUmpoZ5ALQ2VLqwHcqo9WoU4TtnVrc8imxrmrz
   R7y8ZdUJsjse9GtPMOtuD1FH6liez1hOUJm6Q9g5gF+ViQ1c6b3pAd0aJ
   5Dn+kz/rPBQ7QRKMAYrwhTDmG5KBMIP8dx3wmh32lrQMSMuNtL7wxekK9
   Q==;
IronPort-SDR: nOodxX2BUg1V4BcymlU5Ak7SLiIzfI+WJL0GVNfUfDbt+6bKODae4HKe8SFe9fWb3LkuFlKzek
 HsTDBIfLcG1e8oxRh2AMk9wwC/VkvNDlFpdQJXxb1GtXR+BPF3uh0NFcsStwYC1T/1TOAAgXM5
 rjzV0OUkDM0EE9M4pKEiwV9meLsHQhz+7mB1C5Cb0WPKQX7jS1NR5Sf/1alVVhUxrvL0Yt6CdU
 JkRKjiDNTqZGpVMBz0J9vd2xtPpCsCwl5iq+rKcotkCiRgFdnYIkVLT8CFzuQHo2pYUsAOHGUt
 Nmo=
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="242185839"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 18:06:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy3Z5WZtdkuPb/ALwAOKYa++Tyhy6qG+G/1NsEZ4Ku4UWynQosOd5YdmyA3R5I1AFKfhJsJQ1xbAF3LU8ZkZoGhTJQBY1d0hL/t02XkccWO6LzyUi5syz+O9lwdZ9rDlEEwwArEgRHPmOUHk2Hjk7oYBFTpFfSxVscI+VUFlpX2uKlWfv1iVMffFnDEe1FPpS9CfHeyUSk9u06S75rBUQSFQ46SwdxBwBGi6lULc1CEOJzWo62C6WNvXomz12ElKalanXS4IZznbxFMbv6nxiLYYzib8fSFRPbQS8pELju1D+eLUi1b7W8linikBPbJudqJgJdllUkqHgIT1l7Lr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=MkLegytEcviKQcJxMKLusxoKeQKkmbYTvzcOYPVqDEfEb6BP9Le+KpjSa7Q5KLGFlV4wR0fXqIWn32Ftv3cKND0fzG8QxmPEVpqQ6tZCbd8tOF+9ZEdoaPFe6DaoiI6p73xaJ7pr3v9mDFSAqdBl5oFDtMNBUdPh0/qWpTlzP3CuhmIm+pIabwT+ZZRaP9Lk/UgfoI/nEijKgtk/iUTrQPTZtq0aIlggCU76h3yDse55QN9q46bTfkjhn+9Ba56B5VKwLzmyr5mYQ8mh7XHzZReNZuXvIswq7mwauw8qcKbs3ZwGnLuGzKXRsjF7Pw3+s2YEOZsaZA0qCjJg3YKY7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=uvJTHocsLLiVIR7Lt+EqVO+9a049FCY+qgFiZTCwE/EnKxplykQRCfhbW/Cam5w5Y0RGuhPdfkESfw5O2T0AE5DWSxlIvARZC/FiIN2QqePiiyEas7r/AFymCY4lL2M6fHyI7K06/28u8X562GZHW0rld/HKCcEZX+/I96D4yjc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3678.namprd04.prod.outlook.com
 (2603:10b6:803:47::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 27 Mar
 2020 10:06:26 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 10:06:26 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 2/5] null_blk: use blk_mq_init_queue_data
Thread-Topic: [PATCH 2/5] null_blk: use blk_mq_init_queue_data
Thread-Index: AQHWBBKTYkrD89Qg2kSMBui+fGBz4Q==
Date:   Fri, 27 Mar 2020 10:06:26 +0000
Message-ID: <SN4PR0401MB35986322A22EBB92A6D37AF79BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e04f09c2-afcc-4515-3675-08d7d2368310
x-ms-traffictypediagnostic: SN4PR0401MB3678:
x-microsoft-antispam-prvs: <SN4PR0401MB3678BB62CD1B8D34BF46FBA19BCC0@SN4PR0401MB3678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(4326008)(86362001)(55016002)(558084003)(52536014)(66476007)(19618925003)(478600001)(91956017)(2906002)(4270600006)(9686003)(8676002)(76116006)(8936002)(6506007)(66946007)(54906003)(64756008)(66446008)(71200400001)(5660300002)(66556008)(110136005)(81166006)(81156014)(7696005)(186003)(33656002)(316002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OwinqK+x0Hc6q8ZBCFDRGpJq3JMKSm20Cpr/Ghl2+nTaBvj+b0UjsTYc9yEiWeLTm01occ7wTqELHKuS9P9txezekEaijV45Pa1Iz2ZDXz34H31+KTZe6z+R9Vc1Fr3HLB6jFOQlz8zkKuAVseq9IJf6v9Ah+Vo7njx4XZHT+KH9czkn0Ciopzmj7lJTDvC8CPrwE2x7XGUY0oK2q1HKxsJHwyFGmBL/AoUhuz3Jgb2P64UG/hReH7D0tEQKK08Vk/sglNMa6OpDmzWARkqwsQSHBSXMkMPy5BKHGOsF3VDFSTZnu4VFBYDmxSiG6X1AO/2XRjs3Le47nYaZsHENSdycM6wBGO7W+12XOJEaur0xK3erGo9tdq7DptB/R8zaAwxCYjcJvZ/mTzTcwYu8poTHhiLP56IL0dv8G58NSaDhN8fHKfabo9KKUZ9mMI+i
x-ms-exchange-antispam-messagedata: SzetQSmUe/00n047DxGx2y4Od7NhZpAu5lsov9ou28aN7PYE4BwQVMuuCFGfvNBfgFLLf7DmSS8AEg9yaVyaxTOuYKAoJ2igM5cNjRE4a89xgOORZVe9qKNDoT6Y9uGgdhCjAN7F06RQL33Ll46KPg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04f09c2-afcc-4515-3675-08d7d2368310
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 10:06:26.4289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWz7dDnXoMWa5Ex+4Ja5vrzzhPElBDU0bGzJ3KmFtYZXM3bLlAXit/w+TOMyBY8eFJXZlwpVMS3PMZgaY2x91lW1RiRARcQB8obniGeGcjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3678
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
