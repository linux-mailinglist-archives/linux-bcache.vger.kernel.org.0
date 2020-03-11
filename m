Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7540D180E16
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 03:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCKCmi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Mar 2020 22:42:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53714 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgCKCmi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Mar 2020 22:42:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2gPGM098802;
        Wed, 11 Mar 2020 02:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=KfOy4Bpiplasnl/ncLcT96S4AGSmRKSa2SGlhHhNj7c=;
 b=Gfm9v9XcT6XQ+dTH+zLoCwiHouQb3XBcrrPjnFoVSULeMvPSTMRT1AYsdS+YZ/h3e+kK
 4LNGmyUcyHVkh6jH/c00tkOF/3GQZoqbPtYA9xyZ0kk+9/uynbRkFq048YYs1v6zp4Zo
 gxGCrvRgFEyVdsrOwOOqZtjVemeQjSMQoFFQbYD9Fd35xBUFK0CCaSdCmrcXf9Qw+7wj
 ZSq2gsUJfmR3KAUOWCRSA+8OJ99ICISH7J7Dej+rFw1v0UebuiUG/XEBfkkAmf9KIrsx
 CGHydj5mEdJ0zddeM4eAfSZduPG7zVsnIu7uMVCEiXH2n2kBXNidp0HUaJJgxcFeLscF Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v641k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:42:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2g9Bi007440;
        Wed, 11 Mar 2020 02:42:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yp8pvmbc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:42:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02B2gLke024249;
        Wed, 11 Mar 2020 02:42:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 19:42:20 -0700
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
        linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v3] block: refactor duplicated macros
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200311002254.121365-1-mcroce@redhat.com>
Date:   Tue, 10 Mar 2020 22:42:17 -0400
In-Reply-To: <20200311002254.121365-1-mcroce@redhat.com> (Matteo Croce's
        message of "Wed, 11 Mar 2020 01:22:54 +0100")
Message-ID: <yq1k13rr4s6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110015
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Matteo,

> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are
> defined several times in different flavours across the whole tree.
> Define them just once in a common header.
>
> While at it, replace replace "PAGE_SHIFT - 9" with
> "PAGE_SECTORS_SHIFT" too and rename SECTOR_MASK to PAGE_SECTORS_MASK.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
