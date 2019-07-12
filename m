Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF466639C
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Jul 2019 03:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfGLB7u (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 11 Jul 2019 21:59:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbfGLB7t (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 11 Jul 2019 21:59:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1whwI148502;
        Fri, 12 Jul 2019 01:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=J18F5J67mO4t19yyI3zIbTw8aOC1FGxLd1+xZAbv+II=;
 b=252PRaXX3ARUVHnSa0jdQ8LeA3vZLbJcHVF4+se154ImHvp88xn6Kjcyq2w+kSCvPuF1
 fq85ecDc8eESQE7wzf7P8tZYkIp4pEug9Fl+RkdnoYkqQSu0TsMRkritePlmyRKexskT
 YshM2U47AnjM4/25rt34IgTd8tTmS9BAt1UVmTojLyB77yBQsLuILOF6E6KEZ/do/fJ9
 xsl/EePtn6Me0ilDb/kzpVgRUVHuCVtd+Y5qmV2Gf8K1pQl6D9xgURF10pnZMUhTZ9T9
 +YUQxkpYczqmXHF2RcaaWJyCn8mtc+1hcyAiGAQ5eqtQ/li0xqlqen2XDdTsXF3WuEBZ RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tjm9r312q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:59:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1vq19042528;
        Fri, 12 Jul 2019 01:59:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tn1j1vuk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:59:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6C1xSPb003774;
        Fri, 12 Jul 2019 01:59:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 18:59:27 -0700
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, colyli@suse.de,
        linux-bcache@vger.kernel.org, linux-btrace@vger.kernel.org,
        xen-devel@lists.xenproject.org, kent.overstreet@gmail.com,
        yuchao0@huawei.com, jaegeuk@kernel.org, damien.lemoal@wdc.com,
        konrad.wilk@oracle.com, roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 1/9] block: add a helper function to read nr_setcs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
        <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
Date:   Thu, 11 Jul 2019 21:59:24 -0400
In-Reply-To: <20190708184711.2984-2-chaitanya.kulkarni@wdc.com> (Chaitanya
        Kulkarni's message of "Mon, 8 Jul 2019 11:47:03 -0700")
Message-ID: <yq18st457yb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=994
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120023
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Hi Chaitanya,

> +static inline sector_t bdev_nr_sects(struct block_device *bdev)
> +{
> +	return part_nr_sects_read(bdev->bd_part);
> +}

Can bdev end up being NULL in any of the call sites?

Otherwise no objections.

-- 
Martin K. Petersen	Oracle Linux Engineering
