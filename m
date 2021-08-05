Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B244B3E0E35
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Aug 2021 08:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhHEGTf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 02:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhHEGTf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 02:19:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05E6C061765;
        Wed,  4 Aug 2021 23:19:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ca5so6501966pjb.5;
        Wed, 04 Aug 2021 23:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GPxSQQeg/1xiiyvVf6IgyfR1PvTtE3HCXKKlX2KChmc=;
        b=V5w+ybPXrBNZFwHylRHg7rLTipyjlhw9ZDQ76A723nwt4KYZXnpCLhNt5qRXWJLnUz
         ns0pAxgoAX0FbczJG7KHplZcFTegN6qQUKWb/PSSmwZu/OvBw0aHUhbNf7soDCUxpQpu
         dJnsbdhyVy/Mey/zdLlAwQJ4qCmrYe/ZXqRSxEvP/islz8hze1WIb5AsmPhoG/k+6Pmx
         yliX/LegaE3ek+3cBL+qyZYBcYOdCC/tlouQBW3cUQiV/inabja4Uimyhv5d2PiBKLoY
         Q60AKN4ylBZpw4S84Bgk3HjSJ/J8cxSsTDaLqoZ3frHqIliZL+Y6mBTMfQcJvv5O6gyq
         yltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GPxSQQeg/1xiiyvVf6IgyfR1PvTtE3HCXKKlX2KChmc=;
        b=tE787G8F29DLojAOq4MObK+j888ZYaK57tNpcrVhcYjaGkg2GIe+0dz1bOgg0Br7YJ
         P/1xsQ66z6S7mLTL/E4AcR+SnJM2NBB3XiCACjxprSgOg38rtXjaCqkEHgcOSEKOia33
         AXAOzIabSbMrdzwCa0+zhkpXwzzCDEYcXid2fIZF8LIStSlTziZ4z3SD6hxE/rm2q4iQ
         2cM5iEnmnHRhokTS3St39ad1QuTuGh5fCi7YPlrVEeYGHB4NKB1IymmwHqYSSZAS4UkI
         bTV3t5465RQmqB/LrHG2sLGss61hJnpwWoiNAUSYaJGJZOmUuoAj+2qVvbAiB9Lp57gk
         2wEA==
X-Gm-Message-State: AOAM530etfjHyYPhX4Krs+U/p0XP2OWPoOG+peE/hMWIB9fK+bxWZH/i
        Z8H3DijWZQmV/w60q2q/RxiE0PwTL989Zw==
X-Google-Smtp-Source: ABdhPJzeskio9QxTfARCpVMY2gidZf6SLUjVWuxeo150xpv+qmxRaymRfQR/fNIHsIoETSfCeZLEfQ==
X-Received: by 2002:a17:90a:2c0c:: with SMTP id m12mr1622578pjd.107.1628144360352;
        Wed, 04 Aug 2021 23:19:20 -0700 (PDT)
Received: from [192.168.50.71] (ip70-175-137-120.oc.oc.cox.net. [70.175.137.120])
        by smtp.gmail.com with ESMTPSA id k8sm4815975pfu.116.2021.08.04.23.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 23:19:20 -0700 (PDT)
Subject: Re: [PATCH 01/15] bvec: add a bvec_virt helper
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-2-hch@lst.de>
From:   Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Message-ID: <77fc6660-9c6a-0810-d04f-b6661fa0621b@gmail.com>
Date:   Wed, 4 Aug 2021 23:19:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 8/4/2021 2:56 AM, Christoph Hellwig wrote:
> Add a helper to get the virtual address for a bvec.  This avoids that
> all callers need to know about the page + offset representation.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@kernel.org>

-- 
-ck
