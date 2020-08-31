Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0718B2583CC
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Aug 2020 23:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgHaV6t (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 Aug 2020 17:58:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgHaV6s (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 Aug 2020 17:58:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07VLw8mS030289;
        Mon, 31 Aug 2020 14:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=35b7ZS3rM0vTHUtnbAiSUgRG/4x28a4nQj3i1kP80iI=;
 b=NZfEXzCi0qh724giyKxIZCjIUVqvh8bsebbwW5Ra3KbxZCKmUYetsY7CsqauQ+3F10CE
 q+zDra2Fdm2uU3ZDM/MN9208NMJ6j9fsaz0uj7qfNvOAbEDPEXz/uqrSkHAWe0kE/Rtp
 dfqGPLDw71WRJ2ojq3rAy3IGgFBeuChehYE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 337jpnacy9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Aug 2020 14:58:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 14:58:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN0ZllXmKmw51gEjdK/5OF0G99BxsAwvBtfEI8IB5cvHw9Vn92V1veB6KCr3qznaOhsFc/W53yC3GfI7sqeDATQBYLjloSnBDt/r1G/H4jNajgfFWSbZX3CbbwfvruGUigwkjMNIMitQhgH3dxRcD1FlxkdEcmJhXTqdFFPVFtutNp7VBZfTQqubcLwMnLGnWbwNtvKxR+hSLm+6smoprqtn4arJmWm5adXC9ASJefaDyaguDqjN7wX19LJjmmjfjyZIRBPlFvvxP7/j9ZeZ7QLKNRXkOMZPJNREmA4/WRZBTlqb47vhJFrnQChBoqqGHD3nIqI/Nlp18IzP5SK5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35b7ZS3rM0vTHUtnbAiSUgRG/4x28a4nQj3i1kP80iI=;
 b=Kq4Job0BMhM3dgZATbLpT0uKIP2GoxjmX85VIGjrCpQHnVqR1kQDZ/lAaSodlhlGqOQXqbUtadzqX+73pHyOGaFtLgSkDTH2kplyVbi5wW5eC92QjpS8hDlJbU8hk/yb3geJmyuAmpEMo8NTH9sYZcNfS5tEYw+rrzMJ66/R5uog9GhoziK6B8lfx5YHK/K4wRKjcCUt9JCYQQaHHBxfGAuDO82jm3fEl5sROQp8TNuu+SszYssu2TFvmNwxyHSjHuoqSWdgtoZoKeoodEW5QIGdS/sCmXDQMw54mXY3sz5gDp5NzhGNuZvudKmB1e3venVUJP+N5rM7GPJNu+iWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35b7ZS3rM0vTHUtnbAiSUgRG/4x28a4nQj3i1kP80iI=;
 b=giZ/EOdKzedwyRQRdoyWexbY826bbbOitNglqDmWc591uRBU8K93aqwhf7+kgrRYnUmo2PWHoTSR6/5qxigZuudQnBOAnQfdCkoxkQs00O58VJphcsBC0/HILgtOxPvJKxbxOYYrnn+291EhVt63gorpCAP8Fb95ASCWUjJAV04=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2375.namprd15.prod.outlook.com (2603:10b6:a02:91::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Mon, 31 Aug
 2020 21:58:33 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 21:58:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        Coly Li <colyli@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
        Kernel Team <Kernel-team@fb.com>,
        "song@kernel.org" <song@kernel.org>
Subject: Re: [PATCH v2 1/3] block: introduce part_[begin|end]_io_acct
Thread-Topic: [PATCH v2 1/3] block: introduce part_[begin|end]_io_acct
Thread-Index: AQHWda657raMmk9MVkmM9usLIQt186lR25eAgAD8xwA=
Date:   Mon, 31 Aug 2020 21:58:33 +0000
Message-ID: <B87768CF-7E00-4553-8458-D18F853D558C@fb.com>
References: <20200818222645.952219-1-songliubraving@fb.com>
 <20200818222645.952219-2-songliubraving@fb.com>
 <20200831065349.GA2507@infradead.org>
In-Reply-To: <20200831065349.GA2507@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:6d27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb354070-b9e3-4d5a-7a41-08d84df90110
x-ms-traffictypediagnostic: BYAPR15MB2375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23757683D8A7AC4E0BDBBA2BB3510@BYAPR15MB2375.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCrdT4aMhpWCJMLhajhpBxO/+U5Lf8v4alpyAfEkVIEV8lvN1CYqqxk8bS0iJCwd/I56F6N1W67LJXgv6c8SaBGxgFCqx5K3vqK3CD5E3dgbg8MSAMiJ4/ZgjEqKAwj0WjPMshRxDoulxKKXreTVo+S+PzwVMvMbFSFw0jQzSQVnJzu8E0b4VYnwpl6y+LzdLn9OYvVuAI55jKIp8lDw94EOs/PJ6evvygxp4HisPG/TVluVmPCJSb//e9wTYPkfAQB4z/SekWK6KEJ4wGIsIdM/PJltj8PFOF8+O6go1P0a81mFYm65U8TChJyDNztD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(6486002)(66556008)(66476007)(66946007)(8676002)(4326008)(4744005)(76116006)(64756008)(71200400001)(2906002)(186003)(33656002)(66446008)(86362001)(6916009)(54906003)(53546011)(6506007)(83380400001)(5660300002)(6512007)(478600001)(316002)(36756003)(2616005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ct2Ie7R1la8sNKdrZTrRVcIDlksRLAOXcoFPVJsG4QOzcyLIAWSTsYI0J8LDMOG2Y8LT6MuaaeuqjquAS6HgRlDfc/fWqKiqJY8mAaQuL/sk5N2Q0GYO6b934EmmfJbBQLm+gFUtYJu/S6yhWhIgOg2REnhiDeG6b/O27luW4/FVUY5nogYE7AqByFhN+Tblh4x/jG+myOhRn/ezvs04e2flF70p5q3N7wQw5w2zCMYqSuJkb+OlzJz5/owTk93PmM6mZWi+o7mPOeP0QhLMMrnuPraKrsiJSTj+6dlzRlCV9v/imKWL6wQyUZSyT3ZC6nXD87qshiG/LE60YWGoo6uoDGORfM7J8WQ/ocB9xK6jsQNYNjZDy6CPyQetqe+Xq/YgBdBh/4GATmKYZ8jUJg+U/s0EH5Rgtdr1c4Ds0aO3A5AQVQx2TMGQk8QqH9Y6DAHWD8KDnQ6NOarvpATmDN/Ijr90+xBxib6EbMTJc9nk9cwO4k4LiHA84KKvPOi43RkrMmiTi/8O/OWvM7EBannwvTZBTocDFlhfCK8nwUj5hccf2/LbevBs9wOgXWbGE2FcSgVYIfhJlngjKGrDfNSABwGnL9Ve0peh4ol664oyDSqwHj2QTAsryTcnXcPQvcNdex2u6Wd2rlY1U9jViEUuAWwRgef45Cvc1agGE+xA2uisrbP4Pt4ki7/T8O/d
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2875CB7D7297C44FB9BD8C85A178F882@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb354070-b9e3-4d5a-7a41-08d84df90110
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2020 21:58:33.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7w4JP9YcZ8/y8akQvH5f3jsCAdavKAA9DMgY+FsNA9DV7Lksx7n+0vJh0P8PA0lNmp9Oui0gf3kW9ZABlKHeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=614 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310130
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> On Aug 30, 2020, at 11:53 PM, Christoph Hellwig <hch@infradead.org> wrote=
:
>=20
> On Tue, Aug 18, 2020 at 03:26:43PM -0700, Song Liu wrote:
>> These functions can be used to enable iostat for partitions on devices
>> like md, bcache.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> EXPORT_SYMBOL_GPL for new block layer functionality, please.
>=20
> Otherwise this looks good:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph! Will fix and resend v3.=20
