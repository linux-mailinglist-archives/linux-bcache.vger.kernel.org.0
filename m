Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F1A38CBDA
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhEURTd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 13:19:33 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:34364 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhEURTd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 13:19:33 -0400
Received: by mail-pl1-f172.google.com with SMTP id e15so4701229plh.1;
        Fri, 21 May 2021 10:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PKUzbY5iIGLiRwydllRSQJCscB+6IrSLbJrzulbqCPE=;
        b=dYzSHdAktL0ufEBTKxuf+4vv3Pk59mfcHAXlnAvloTorLrIkMzLCDFQufV7UciYBDV
         hcLWq6D9UtcV1gFHFXibOCZkU0grbSOOz8NqJkNx/OkJdr2GiL43dKkghnmKrmZrChFd
         GQYpMjsTKxoyxoTYZvHI/qFV0Q9WXklvLeCzn/f2oY4q66kFr1IVmDSxEE/+volMG3eL
         HHI+obCY+I/ZbFkPbLnDYct/Tfa4xt4TA4s07nESVMmc34WBrd7ijvIJ/cxN3Ffp0VLW
         ILANYQWmMBHOittVda8GTyfDtTYN8YnJIN1jYslxqzSP/uM3gIYd7edr3JdjPMv9n0pu
         EMoQ==
X-Gm-Message-State: AOAM533p6CuREptR+8JVA14eRzofl4F7CXS5Ll37Jru6CXW9Zv0IlMBJ
        Okh72HPucLbXIMn9zHHLVIU=
X-Google-Smtp-Source: ABdhPJwK8NtIAa5B5/oxZS0IR7nB67qYtN97nOKjvFJRfkRjUCvWO1h3QwEBBuBpXaKTLAx6Ca3tYw==
X-Received: by 2002:a17:903:30c4:b029:f0:ad43:4ca with SMTP id s4-20020a17090330c4b02900f0ad4304camr12902892plc.70.1621617489433;
        Fri, 21 May 2021 10:18:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id f5sm9178273pjp.37.2021.05.21.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:18:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 29A6B423A3; Fri, 21 May 2021 17:18:07 +0000 (UTC)
Date:   Fri, 21 May 2021 17:18:07 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 02/26] block: move the DISK_MAX_PARTS sanity
 check into __device_add_disk
Message-ID: <20210521171807.GA25090@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 07:50:52AM +0200, Christoph Hellwig wrote:
> Keep this together with the first place that actually looks at
> ->minors and prepare for not passing a minors argument to
> alloc_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
