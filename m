Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AB5660716
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 20:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbjAFTZE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 14:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjAFTY6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 14:24:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB5777AD2
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 11:24:57 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c6so2660542pls.4
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jan 2023 11:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fiUE7qV3TeV37sE/MZLGbTWtsmtid5YxK7EKlhT6SGg=;
        b=MXH8ZdJjYceMJd78W18JC6QxLzARKE3ZtdTSLjQwai1d3HdQPJ4fOdw2sEpu8yOMN3
         I51Kadx9i3axJMZ0Kvw3GWIn2uq9Va+t0zMmXjj50Taw3qrHOG+4OEO1DGh0Jb7O9raH
         nEqmB/bNEPCTQPOLc0APx/JhQ6E4JMVU4MKHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiUE7qV3TeV37sE/MZLGbTWtsmtid5YxK7EKlhT6SGg=;
        b=mpazfQznx/juy1PaJbOxqqJRWhr3w6XTI0esOVfMWMcbMsss+ELuPjcRLo7PSrn7PW
         GcfDJwcQMCM9UyjnNyMp9WrF2+gaUbGe1qzbKEpKz+sjKQoAbYJRuqMx139MCUvMyh1z
         zsf7LFOppdrf8ueHpBt2NrpwZlBBOtIFkUxm2KK64TFYGKZ9yGXrcFGo7doeQ3OUQu90
         GHIdwWh2vm25sexUJEyrzrmyzYYVxlYX6OzB0seGK3lDWg2BtialDIqo/M3SPAoI6jKA
         O8joVVA+iu2zjdMdGImfD91sy+PV33fNDiacBY/fsTJo8bEjBKC9Gqz7b5x1ylosl/hY
         npWw==
X-Gm-Message-State: AFqh2krKTFOT2aogsfalUqo3nOOZ3gQ5Df/RDfXFBR88HCMHN1/hKqiT
        aow6Y5xYOXJ6oPCvNOq/J3rU3Q==
X-Google-Smtp-Source: AMrXdXtYF5piKCXiUZQXel2DI8vWqRDQ2w9OM/03QCu8R/HdiOeb5HUA7z5UHy5QM+F6NCGh5/i7qw==
X-Received: by 2002:a17:90b:238d:b0:225:cc25:8037 with SMTP id mr13-20020a17090b238d00b00225cc258037mr52191457pjb.31.1673033097054;
        Fri, 06 Jan 2023 11:24:57 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a410600b00225dfb6e8b3sm3164308pjf.11.2023.01.06.11.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 11:24:56 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:24:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcache: Silence memcpy() run-time false positive warnings
Message-ID: <202301061124.E4F9C502@keescook>
References: <20230106060229.never.047-kees@kernel.org>
 <132043f4-d19a-911d-04c4-a24fdf89153f@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <132043f4-d19a-911d-04c4-a24fdf89153f@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Jan 06, 2023 at 11:01:05AM +0100, Thorsten Leemhuis wrote:
> Credit where credit is due, this should be:
> 
> Reported-by: Alexandre Pereira <alexpereira@disroot.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216785

Ah-ha, thank you! I've updated this.

-- 
Kees Cook
