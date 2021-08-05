Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6763E0E39
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Aug 2021 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhHEGUA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 02:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhHEGT7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 02:19:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579D3C061765;
        Wed,  4 Aug 2021 23:19:46 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh14so6531106pjb.2;
        Wed, 04 Aug 2021 23:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Us8M4Gz10TOU+v1I5NsNfx0zgCQlwHS7fXqY8nkODX4=;
        b=NmphZcKHDr5rzeeiJu0gciOePeopU2TUfYviW4P0HGDE7eQ7rlOkWulSippslpN7hI
         KbiuY7BMkNLpA3KqdMnGptqECAiI0U+Ak9aV80XIgQ6d7TzHsqM4uDuFBN/RjTWP4dFi
         v2wWmB7dicFmiRtF/+fN1KXwh1JHYKc7Cccp5WBNRYX1xc9WfWeQ98S5ZK3t/bQ/YWsA
         1tn0ksVptVHOuY5mogE+aT/nGQLlOduKg9Neq8j/WElHzV63gKu4Ou+WpOPovZW8GC3S
         lTU8D0eXfSbhbH4EHGHVR3wXlcn80rxe2kU9gIf02PVZUsle8ZWaAo8SBvhe2OpOLwMx
         u/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Us8M4Gz10TOU+v1I5NsNfx0zgCQlwHS7fXqY8nkODX4=;
        b=sA9cQNxq2I33w0ZIQSK3ezX+IhwzyK1VuFNlBJljZ97J8xbw+OOhUUcJWv04nB6Xm8
         iq9u8t7QCNOXJLt5XEflAAjgvmvGW1aS8Ar3uM6fqQ7CbFWzVKRFSgmbleb69aPxTXqu
         jnyYNlrz12vldMXzIdwDBPoAPhVE2/qTFLSYGH/DJO3gh/2bjFzOBBFQbtn/Xf8s1R4q
         tmbKeqchqderb7WQsjmVXyZSwYHvGHCb8jOW6AiikqmA8/yC6gl72fyVgoGuPZqQWCYt
         Vmy6cbMXv00QgM7rdjn5ao+1PESf0nGlkHGCr9uafBom2OBMXCuh8aaKAm+IPylVy3e8
         b5QA==
X-Gm-Message-State: AOAM532+g30XS73peaNKFVROyXy9XeVbRSlnEk4jOe93ALlWDSg6FoKe
        K7n6KU/vDHLbrDZl74+m2QQPspcbt/nwiw==
X-Google-Smtp-Source: ABdhPJylCwEmCslg5aa1nc2EitMfnv0khm5CC20SSkcpOfTgA4if26raJjt9hmbh77ooLfOKEQ2BOg==
X-Received: by 2002:a17:90a:fef:: with SMTP id 102mr13385008pjz.148.1628144385681;
        Wed, 04 Aug 2021 23:19:45 -0700 (PDT)
Received: from [192.168.50.71] (ip70-175-137-120.oc.oc.cox.net. [70.175.137.120])
        by smtp.gmail.com with ESMTPSA id l11sm5198375pfd.187.2021.08.04.23.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 23:19:45 -0700 (PDT)
Subject: Re: [PATCH 02/15] block: use bvec_virt in
 bio_integrity_{process,free}
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
 <20210804095634.460779-3-hch@lst.de>
From:   Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Message-ID: <b1d05349-86d2-0334-436f-811600ee1578@gmail.com>
Date:   Wed, 4 Aug 2021 23:19:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 8/4/2021 2:56 AM, Christoph Hellwig wrote:
> Use the bvec_virt helper to clean up the bio integrity processing a
> little bit.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@kernel.org>

-- 
-ck
