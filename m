Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E540F4CC04E
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 15:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiCCOtg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 09:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCCOtf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 09:49:35 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AD3DE2EB;
        Thu,  3 Mar 2022 06:48:47 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f8so6905449edf.10;
        Thu, 03 Mar 2022 06:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQjVRiRy4c9jIh4S1Ufiz+FcO3tGme0RXIPV+Ov5R88=;
        b=EQdJDzX7NFx14kL8xqT702212BvVbZJpWWokIRXjVnhTyHeCrnBE7B7lEoL18+gEYD
         M3mKOO09/tmQqUxX1EMtZnHer479xBWbYHxTaVQZ3YR9mbWzrww9FU4hSuR075gGA6s0
         v4xlntKVirqILvLUr8XdVcN9YdebJlUHHXHvEbqhEL3USNWbjom6Z4PXfkTriUB4CIgi
         FTijWrdp7q4Ljkk1KYnRzy9RnUhzMS95JuKsTvmDZx20R+Pil74ShK02YTKeEzEoBiY7
         i0DMRV5pNvJYJszjmeh1of5k7oLEElNbxeqldYS8jjZcFR8zHpWaAfLTlSr+yKfxUF4E
         EIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQjVRiRy4c9jIh4S1Ufiz+FcO3tGme0RXIPV+Ov5R88=;
        b=pqr8wXTRQRudVXbNhoYtyEdzOx61oVg9cmN6vBX52pU9W3uPpkpfBhWxWrSkCoLMZq
         wi/ZlCRxs73aYYNBNqa/5B5TTV6q9PSYECfs8TIhfnUqMS8GxRW2jhA2de/oXWwOlgVk
         f2qjAHjh7ANGcrg74e0gdDJsNKHUY/TRFWpdHV87ZTtb1QIPyaUgHrcI3sbAWvbA5JkX
         2mk9WOhL/xen/gYYaxkZQ6cWw7h8TxCfsBTJ/BtbvK4QEL9nsYOCSK57LYqRHvb2o9pP
         MnzM/hm6srFBYgAnKD1GW/Eh8CF3hPOfxfVLbMSJL5iL5FFZugp39tTIWf0T6F4iaVPb
         cblg==
X-Gm-Message-State: AOAM531E7OqYyXwyVAnEXBCoAjPQA6TojyY6MZkEg4uWc/lFMfJaCxhY
        kTnh/76DZODbcKFDyQVsjtu7VqEBLMO6cgwFI0k=
X-Google-Smtp-Source: ABdhPJxC3/F/nITnZ/dqhO7GQgKGUK3h0VPxhHt7adLIhtss+vOHVIU3L0u1AGN7d9ozXDr2PI4BaDWp2YreGH6K+2o=
X-Received: by 2002:a05:6402:492:b0:404:c4bf:8b7e with SMTP id
 k18-20020a056402049200b00404c4bf8b7emr34256179edv.318.1646318926214; Thu, 03
 Mar 2022 06:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20220303111905.321089-1-hch@lst.de> <20220303111905.321089-2-hch@lst.de>
In-Reply-To: <20220303111905.321089-2-hch@lst.de>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Thu, 3 Mar 2022 06:48:34 -0800
Message-ID: <CAMo8BfKgtEVU2qpu3BQqQB7cxtPzF-Hmuifr4xEhe0TRiyJ=WQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in simdisk_submit_bio
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Mar 3, 2022 at 3:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  arch/xtensa/platforms/iss/simdisk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
