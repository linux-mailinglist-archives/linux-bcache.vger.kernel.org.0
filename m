Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A413C3E1990
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Aug 2021 18:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhHEQb5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 12:31:57 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:56138 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbhHEQb0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 12:31:26 -0400
Received: by mail-pj1-f44.google.com with SMTP id ca5so10130954pjb.5;
        Thu, 05 Aug 2021 09:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hHUTsKDnxap0EiJI1vbHiNIpoH+R0H2TboThtqpCWSc=;
        b=lhkCxai7p7X3kxlL+3aFu4AkkT/AuEAkn4qjbZ5qp7nA2Ve4sA9kaHiXjwKbegxXxl
         bdDFiS35OADff4FyLBYrr+MIJOFxvC/z7uIma/WqUWN1gR75oE51jG8z+0DV9FY9iVtA
         AhaUsltZUkl0UcQPG3YZUVQf2mtUqZ1BQQZOQ7AgxpNXQ2dIFZA+stbDCUHxi0jyB8r1
         YtF5f/F0OSHgERAttAZpWuSdVMauY8O/qRqs0YXTBkaF6kSCTIebS9eQC6VAu2cNynsK
         r1vGbFMBECcXVlYtH9t72lBoIqfxq2qqw/4YyJZMQR5E2j5SaGAHtoDExfDtYwSi/Pn/
         7NIw==
X-Gm-Message-State: AOAM532NVQvi01jv+RTHcRVQQEM2540eDDCJlxLSDDFCCq3csShDM8I/
        3CXxi/n2nx1Fkt/eca0RHO8=
X-Google-Smtp-Source: ABdhPJyCuisk5RzZy6da7AsZoR/DaZLZHn4oZn9ITXuwK2Rjv1pBKXahTV8aXSruiOZbF6hVQSA8vQ==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr15924247pjp.29.1628181071870;
        Thu, 05 Aug 2021 09:31:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id r4sm6334361pjo.46.2021.08.05.09.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 09:31:10 -0700 (PDT)
Subject: Re: [dm-devel] [PATCH 10/15] sd: use bvec_virt
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Jan Hoeppner <hoeppner@linux.ibm.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-um@lists.infradead.org, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        Stefan Haberland <sth@linux.ibm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geoff Levand <geoff@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-11-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b487c0f-71be-19d6-249c-9cd1ba228548@acm.org>
Date:   Thu, 5 Aug 2021 09:31:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-11-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/4/21 2:56 AM, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b8d55af763f9..5b5b8266e142 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -886,7 +886,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
>   	cmd->cmnd[0] = UNMAP;
>   	cmd->cmnd[8] = 24;
>   
> -	buf = page_address(rq->special_vec.bv_page);
> +	buf = bvec_virt(&rq->special_vec);
>   	put_unaligned_be16(6 + 16, &buf[0]);
>   	put_unaligned_be16(16, &buf[2]);
>   	put_unaligned_be64(lba, &buf[8]);

The patch description is not correct. The above patch involves a 
functional change while the patch description suggests that no 
functionality has been changed.

Although the above patch looks fine to me, why has page_address() been 
changed into bvec_virt() in the sd driver? My understanding is that the 
sd driver always sets bv_offset to zero.

Thanks,

Bart.


