Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94625435935
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Oct 2021 05:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJUDqs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 23:46:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30404 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231530AbhJUDqK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 23:46:10 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L345vU029738;
        Thu, 21 Oct 2021 03:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=BSjTWby1MMCLQUchrOSGc4QoXnzcMZ91l35lRX12C+A=;
 b=s10GXTgGaX78Zmg+DOSDrfc0P0mwy8l94S/NZcyOPTkKyIMY2Y0KlCwxCAx31besDrcr
 gXfw3fEKtGCdejoVtEWUD00kuevcL/euKQ1b4LL0nm4E8CV6SIOFqCYP0rxj7RC74EVk
 e1PqokwRndi0pkrqAVruOVLwEN5l5viuqDFrINzci/HP18Znfe79FD5iVhadUThPY2uw
 odRGpVz8brO185YsW3tTaXuLihuEjMaflid8MLFI6u/8vn+luvxy/mDr7zofRsdPscVh
 mNLR9sg3Koj94WqKMhqpn6d0kreDZqZeu97CD8yHp5SK3EUYUYKj0bD7U5PsVZFWhw4s kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etve078225;
        Thu, 21 Oct 2021 03:43:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:08 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8A082116;
        Thu, 21 Oct 2021 03:43:07 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-13;
        Thu, 21 Oct 2021 03:43:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     zhuyifei1999@gmail.com, thehajime@gmail.com, hare@suse.de,
        jinpu.wang@ionos.com, jgross@suse.com, johannes.berg@intel.com,
        geert@linux-m68k.org, linux-mtd@lists.infradead.org,
        miquel.raynal@bootlin.com, axboe@kernel.dk,
        Luis Chamberlain <mcgrof@kernel.org>, jdike@addtoit.com,
        kent.overstreet@gmail.com, richard@nod.at, colyli@suse.de,
        agk@redhat.com, haris.iqbal@ionos.com, krisman@collabora.com,
        roger.pau@citrix.com, anton.ivanov@cambridgegreys.com,
        sstabellini@kernel.org, ulf.hansson@linaro.org, vigneshr@ti.com,
        chris.obbard@collabora.com, jejb@linux.ibm.com,
        boris.ostrovsky@oracle.com, tj@kernel.org, snitzer@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-um@lists.infradead.org, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 0/9] block: reviewed add_disk() error handling set
Date:   Wed, 20 Oct 2021 23:42:44 -0400
Message-Id: <163478764105.7011.9400354892813636458.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: BAR8nzodBeKYX4DEPTjC7SU079lshTb2
X-Proofpoint-GUID: BAR8nzodBeKYX4DEPTjC7SU079lshTb2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 15 Oct 2021 16:30:19 -0700, Luis Chamberlain wrote:

> Jens,
> 
> I had last split up patches into 7 groups, but at this point now
> most changes are merged except a few more drivers. Instead of creating
> a new patch set for each of the 7 groups I'm creating 3 new groups of
> patches now:
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/9] scsi/sd: add error handling support for add_disk()
      https://git.kernel.org/mkp/scsi/c/2a7a891f4c40
[2/9] scsi/sr: add error handling support for add_disk()
      https://git.kernel.org/mkp/scsi/c/e9d658c2175b

-- 
Martin K. Petersen	Oracle Linux Engineering
