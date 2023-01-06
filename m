Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBD065FB64
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 07:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjAFGWG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 01:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjAFGWG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 01:22:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4228E43A18
        for <linux-bcache@vger.kernel.org>; Thu,  5 Jan 2023 22:22:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o21so644655pjw.0
        for <linux-bcache@vger.kernel.org>; Thu, 05 Jan 2023 22:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P3P39B3+R/DWnUo27dj0CuajbLtQj508AlEFbLQeeco=;
        b=gFfwNN2cBsPVNqo5NLC1hz0fbBDjCCVekPUQUzDXQiNrz3vaAbuoC2l2Rcv5KDD1BR
         GGUDQU1BU/ZGDR7W9+LH+2DU1RDh1tJ3gm2EJRk9EzScNFktUgzFV4suePITtV+8chsg
         2hXm3VHigwfCzIzwicjfr2JbSL9rgoJAREUDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3P39B3+R/DWnUo27dj0CuajbLtQj508AlEFbLQeeco=;
        b=F/jgO+RFo4kwlLgDp74I9Ntmnc1raNGKN50grfD6AoRzTmjKi0H1tHs2WYpAVclCdv
         ZAMfKS2y8PYRJYmfCUrAKG8ZeoAWnthEVoM8pMUPhMryZH24i9uz9UEHzufMAtLkaoaT
         LhnOYxu+tVP1EDTk9LQaNWQQRavWaFCjjAaGzjW9GkHzDJo+/nfp9Jh5yZfQnU0SrZX2
         yjX/Bka+5ZpiHLn3pTH4ivYcHIyar+6UOxk+fP2MnyF7Ui0dNSrATjvZ9YY6wqpRNCur
         7nvmoP1kBF3ApGiZnk3pCX3mM6LM/D7J5T82RApLPYNhOm/A2bFyxrKAjHVxrzNusAAL
         j0vg==
X-Gm-Message-State: AFqh2kpvcC2wlhwyeC5Ha+35QDELWmJQ8Nj3IZEPVn5ODbLRdnExBeqv
        Ci9cmRBw45ccN9LUluGYQ8kiQw==
X-Google-Smtp-Source: AMrXdXtM1vP5dcgTHPDfmr3om3PPOARVroyAjqYZI9GdQBO0YB4PrzpyQj622REF2D7RDm2EKP3p1w==
X-Received: by 2002:a17:90a:d78b:b0:219:34cb:477e with SMTP id z11-20020a17090ad78b00b0021934cb477emr57605129pju.44.1672986124780;
        Thu, 05 Jan 2023 22:22:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y128-20020a633286000000b004768ce9e4fasm257954pgy.59.2023.01.05.22.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 22:22:04 -0800 (PST)
Date:   Thu, 5 Jan 2023 22:22:03 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] =?iso-8859-1?Q?Bug=A02167?=
 =?iso-8859-1?Q?85_-_=22memcpy=3A_detected_field-spannin?= =?iso-8859-1?Q?g?=
 write..." warnings with bcache #forregzbot
Message-ID: <202301052218.042D2BFE@keescook>
References: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
 <2e4e65a8-87b4-fac6-ef89-76b118b0cec4@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e4e65a8-87b4-fac6-ef89-76b118b0cec4@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Dec 15, 2022 at 08:11:06AM +0100, Thorsten Leemhuis wrote:
> [Note: this mail contains only information for Linux kernel regression
> tracking. Mails like these contain '#forregzbot' in the subject to make
> then easy to spot and filter out. The author also tried to remove most
> or all individuals from the list of recipients to spare them the hassle.]
> 
> On 08.12.22 15:53, Thorsten Leemhuis wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=216785 :
> > 
> >>  Alexandre Pereira 2022-12-07 18:51:55 UTC
> >>
> >> Testing linux kernel 6.1-rc8, I have several kernel erros regarding bcache.
> >>
> >> For context, I have a bcache configuration that is working without issues on 6.0.x and previous versions.
> >>
> >> The errors:
> >>
> >> dez 07 18:33:45 stormtrooper kernel: ------------[ cut here ]------------
> >> dez 07 18:33:45 stormtrooper kernel: memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
> 
> #regzbot inconclusive: stop tracking field-spanning write warnings, they
> come from a new security feature
> 
> https://lore.kernel.org/all/20210727205855.411487-1-keescook@chromium.org/
> 
> Tracking them would cost time I better spend on more important things
> for now

FWIW, I'd find it handy to see these. I've been trying to track and fix
them. To that end, I've just sent out the following patches:

https://lore.kernel.org/lkml/20230106045327.never.413-kees@kernel.org/
https://lore.kernel.org/lkml/20230106053153.never.999-kees@kernel.org/
https://lore.kernel.org/lkml/20230106060229.never.047-kees@kernel.org/
https://lore.kernel.org/lkml/20230106061659.never.817-kees@kernel.org/

Thanks!

-Kees

-- 
Kees Cook
